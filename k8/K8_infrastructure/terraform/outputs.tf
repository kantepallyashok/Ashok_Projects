output "vpc_id" {
  value = aws_vpc.k8s_vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "k8s_master_asg_id" {
  value = aws_autoscaling_group.k8s_master_asg.id
}

output "k8s_worker_asg_id" {
  value = aws_autoscaling_group.k8s_worker_asg.id
}

output "load_balancer_dns" {
  value = aws_elb.k8s_load_balancer.dns_name
}
