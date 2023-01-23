# Terraform should display S3 Bucket ID, EFS volume ID, EC2 instance ID, Security Group ID, Subnet ID as part of output 

# S3 Bucket ID
output "s3_bucket_id" {
  value     = aws_s3_bucket.my_bucket.id
}

# EFS volume ID
output "efs_volume_id" {
  value     = aws_efs_file_system.NetSPI_file_system.id
}

# EC2 instance ID
output "ec2_instance_id" {
  value     = aws_instance.ec2_instance.id
}

# Security Group ID
output "security_group_id" {
  value     = aws_security_group.ssh_ec2_security_group.id
}

# Subnet ID
output "subnet_id" {
  value     = aws_default_subnet.default_az1.id
}