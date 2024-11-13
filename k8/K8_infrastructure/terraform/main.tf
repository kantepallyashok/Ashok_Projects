provider "aws" {
  region = var.region
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.subnet_a_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.cluster_name}-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.subnet_b_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.cluster_name}-subnet-b"
  }
}

resource "aws_security_group" "k8s_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access to the Kubernetes API from anywhere
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

resource "aws_iam_role" "k8s_role" {
  name = "${var.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_instance_profile" "k8s_instance_profile" {
  name = "${var.cluster_name}-instance-profile"
  role = aws_iam_role.k8s_role.name
}

resource "aws_launch_configuration" "k8s_master" {
  name_prefix          = "${var.cluster_name}-master-"
  image_id             = "ami-0c55b159cbfafe1f0"  # Update with the latest Amazon Linux 2 AMI
  instance_type        = "t2.medium"
  security_groups      = [aws_security_group.k8s_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Install kubeadm, kubelet, and kubectl
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
              yum install -y kubelet kubeadm kubectl
              systemctl enable kubelet && systemctl start kubelet
              
              # Initialize Kubernetes master
              kubeadm init --pod-network-cidr=10.244.0.0/16

              # Set up kubeconfig for kubectl access
              mkdir -p /home/ec2-user/.kube
              cp -i /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
              chown ec2-user:ec2-user /home/ec2-user/.kube/config

              # Generate and store the join command in SSM Parameter Store
              kubeadm token create --ttl 0
              JOIN_COMMAND=$(kubeadm token create --ttl 0 --print-join-command)
              aws ssm put-parameter --name "/${var.cluster_name}/kubeadm_join_command" --value "$JOIN_COMMAND" --type SecureString
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8s_master_asg" {
  launch_configuration = aws_launch_configuration.k8s_master.id
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [aws_subnet.subnet_a.id]

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-master"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "k8s_worker" {
  name_prefix          = "${var.cluster_name}-worker-"
  image_id             = "ami-0c55b159cbfafe1f0"  # Update with the latest Amazon Linux 2 AMI
  instance_type        = "t2.medium"
  security_groups      = [aws_security_group.k8s_sg.id]
  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.id

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              
              # Install kubeadm, kubelet, and kubectl
              curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
              echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
              yum install -y kubelet kubeadm kubectl
              systemctl enable kubelet && systemctl start kubelet
              
              # Retrieve and execute the join command from SSM Parameter Store
              JOIN_COMMAND=$(aws ssm get-parameter --name "/${var.cluster_name}/kubeadm_join_command" --with-decryption --query "Parameter.Value" --output text)
              $JOIN_COMMAND
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8s_worker_asg" {
  launch_configuration = aws_launch_configuration.k8s_worker.id
  min_size            = var.node_min_size
  max_size            = var.node_max_size
  desired_capacity    = var.node_desired_size
  vpc_zone_identifier = [aws_subnet.subnet_b.id]

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker"
    propagate_at_launch = true
  }
}

resource "aws_elb" "k8s_load_balancer" {
  name               = "${var.cluster_name}-elb"
  availability_zones = [var.availability_zone]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port          = 80
    lb_protocol      = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.cluster_name}-elb"
  }

  # Attach the instances in the Auto Scaling Group
  depends_on = [aws_autoscaling_group.k8s_worker_asg]
}

resource "aws_route53_record" "k8s_dns" {
  zone_id = "<YourRoute53ZoneID>"  # Replace with your Route 53 Zone ID
  name    = "${var.cluster_name}.example.com"  # Replace with your desired domain
  type    = "A"

  alias {
    name                   = aws_elb.k8s_load_balancer.dns_name
    zone_id                = aws_elb.k8s_load_balancer.zone_id
    evaluate_target_health = true
  }
}
