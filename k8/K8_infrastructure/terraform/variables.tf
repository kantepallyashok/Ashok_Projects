variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_a_cidr_block" {
  description = "CIDR block for subnet A"
  type        = string
}

variable "subnet_b_cidr_block" {
  description = "CIDR block for subnet B"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes Cluster Name"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the Kubernetes cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the Kubernetes node group"
  type        = string
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}
