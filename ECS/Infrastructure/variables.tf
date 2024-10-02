# Variables for AWS ECS and Infrastructure Configuration

variable "env" {
  description = "The environment for deployment (dev, stage, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the resources"
  type        = string
}

variable "ec2_ami" {
  description = "The AMI ID to use for EC2 instances"
  type        = string
}

variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "ecs_task_cpu" {
  description = "The amount of CPU to allocate to the ECS task"
  type        = string
}

variable "ecs_task_memory" {
  description = "The amount of memory to allocate to the ECS task"
  type        = string
}

variable "ecs_service_desired_count" {
  description = "The desired number of ECS service tasks"
  type        = number
}

variable "frontend_image" {
  description = "Docker image for the frontend service"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend service"
  type        = string
}

variable "db_username" {
  description = "The database username for RDS"
  type        = string
}

variable "db_password" {
  description = "The database password for RDS"
  type        = string
  sensitive   = true  # This marks the variable as sensitive
}
