output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "security_group_id" {
  value = aws_security_group.os.id
}

output "ec2_instance_id" {
  value = aws_instance.app.id
}

output "db_instance_id" {
  value = aws_db_instance.db.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static_files.bucket
}
