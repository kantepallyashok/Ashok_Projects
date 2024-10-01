# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

data "aws_availability_zones" "available" {}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "os" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.os_security_group_id
  }
}

# EC2 Instance
resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.os.id]

  tags = {
    Name = "${var.vpc_name}-ec2-instance"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "db" {
  name       = "${var.vpc_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id]

  tags = {
    Name = "${var.vpc_name}-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "db" {
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  engine                 = "mysql"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.os.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name

  tags = {
    Name = "${var.vpc_name}-rds-instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "static_files" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.vpc_name}-static-files"
  }
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = var.cloudwatch_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_threshold

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [var.sns_topic_arn]
}

# SNS Topic
resource "aws_sns_topic" "alarm" {
  name = "${var.vpc_name}-sns-topic"

  tags = {
    Name = "${var.vpc_name}-sns-topic"
  }
}
