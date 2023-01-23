# Creating Amazon EFS File system
resource "aws_efs_file_system" "NetSPI_file_system" {
# Creating the AWS EFS lifecycle policy
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
    # Tagging the EFS File system with its value as NetSPI_file_system
  tags = {
    Name = "NetSPI_file_system"
  }  
}

# Creating the EFS access point for AWS EFS File system
resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.NetSPI_file_system.id
}
# Creating the AWS EFS System policy to transition files into and out of the file system.
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.NetSPI_file_system.id
# The EFS System Policy allows clients to mount, read and perform 
# write operations on File system 
# The communication of client and EFS is set using aws:secureTransport Option
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.NetSPI_file_system.arn}",
            "Action": [
                "elasticfilesystem:ClientMount",
                "elasticfilesystem:ClientRootAccess",
                "elasticfilesystem:ClientWrite"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}
# Creating the AWS EFS Mount point in a specified Subnet 
# AWS EFS Mount point uses File system ID to launch.
resource "aws_efs_mount_target" "mount_target" {
  file_system_id = aws_efs_file_system.NetSPI_file_system.id
  subnet_id      = aws_default_subnet.default_az1.id

  # security groups
  security_groups = [aws_security_group.ssh_ec2_security_group.id]
}

# Creating Mount Point for EFS
resource "null_resource" "configure_nfs" {
depends_on = [aws_efs_access_point.test, aws_efs_mount_target.mount_target]
connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file(local_file.ssh_key.filename)
    host     = aws_instance.ec2_instance.public_ip
}
provisioner "remote-exec" {
inline = [
    "sudo mkdir -p /data/test",
    "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.NetSPI_file_system.dns_name}:/ /data/test",
  ]
 }
}