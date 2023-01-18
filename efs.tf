resource "aws_efs_file_system" "NetSPI-efs-volume" {
  creation_token = "NetSPI-efs"
}


resource "aws_efs_mount_target" "NetSPIefs" {
  file_system_id  = aws_efs_file_system.NetSPI-efs-volume.id
  subnet_id       = aws_subnet.NetSPI-subnet.id
  security_groups = [aws_security_group.NetSPI_SG.id]
}

