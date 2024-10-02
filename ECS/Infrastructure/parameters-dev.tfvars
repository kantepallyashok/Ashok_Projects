# Development Environment Variables
env                 = "dev"
aws_region          = "us-east-1"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone   = "us-east-1a"
ec2_ami             = "ami-0123456789abcdef0"  # Replace with a valid AMI ID
ec2_instance_type   = "t2.micro"
ecs_task_cpu        = "256"  # 256 CPU shares
ecs_task_memory     = "512"  # 512 MB
ecs_service_desired_count = 1
frontend_image      = "myorg/frontend:latest"  # Replace with your actual image
backend_image       = "myorg/backend:latest"   # Replace with your actual image
db_username         = "devuser"
db_password         = "devpassword"
