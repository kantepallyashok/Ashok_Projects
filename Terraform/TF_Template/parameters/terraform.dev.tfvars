aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-vpc"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidr  = "10.0.2.0/24"
key_name             = "dev-key-pair"
instance_type        = "t2.micro"
ami_id               = "ami-0c55b159cbfafe1f0"
os_security_group_id = "sg-12345678"
db_instance_class    = "db.t2.micro"
db_name              = "dev_db"
db_username          = "admin"
db_password          = "devpassword"
bucket_name          = "dev-static-files"
cloudwatch_alarm_name = "dev-cpu-alarm"
alarm_threshold      = 80
sns_topic_arn        = "arn:aws:sns:us-east-1:123456789012:DevNotifications"