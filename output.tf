# output "aws_s3_bucket" {
#   value = aws_s3_bucket.richard-demo-net
# }

output "efs_volume" {
  value = aws_efs_file_system.NetSPI-efs-volume.id
}
output "es2_id" {
  value = aws_instance.NetSPI-server-instance.id
}
output "aws_sg" {
  value = aws_security_group.NetSPI_SG.id
}
output "subnet_id" {
  value = aws_subnet.NetSPI-subnet.id
}