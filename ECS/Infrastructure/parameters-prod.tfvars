# Production Environment Variables
env                 = "prod"
aws_region          = "us-east-1"
vpc_cidr            = "10.2.0.0/16"
public_subnet_cidr  = "10.2.1.0/24"
private_subnet_cidr = "10.2.2.0/24"
availability_zone   = "us-east-1a"
ec2_ami             = "ami-0123456789abcdef0"  # Replace with a valid AMI ID
ec2_instance_type   = "t3.medium"
ecs_task_cpu        = "1024"  # 1 CPU
ecs_task_memory     = "2048"  # 2 GB
ecs_service_desired_count = 3
frontend_image      = "myorg/frontend:latest"  # Replace with your actual image
backend_image       = "myorg/backend:latest"   # Replace with your actual image
db_username         = "produser"
db_password         = "prodpassword"
