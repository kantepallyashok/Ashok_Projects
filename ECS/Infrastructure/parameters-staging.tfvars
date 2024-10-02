# Staging Environment Variables
env                 = "stage"
aws_region          = "us-east-1"
vpc_cidr            = "10.1.0.0/16"
public_subnet_cidr  = "10.1.1.0/24"
private_subnet_cidr = "10.1.2.0/24"
availability_zone   = "us-east-1a"
ec2_ami             = "ami-0123456789abcdef0"  # Replace with a valid AMI ID
ec2_instance_type   = "t2.medium"
ecs_task_cpu        = "512"  # 512 CPU shares
ecs_task_memory     = "1024"  # 1 GB
ecs_service_desired_count = 2
frontend_image      = "myorg/frontend:latest"  # Replace with your actual image
backend_image       = "myorg/backend:latest"   # Replace with your actual image
db_username         = "stageuser"
db_password         = "stagepassword"
