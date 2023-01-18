terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


data "aws_eip" "NetSPI_EIP" {
  filter {
    name   = "tag:Project"
    values = ["NetSPI_EIP"]
  }
}

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "project_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "project_key" {
  key_name   = "project_key"
  public_key = tls_private_key.project_key.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.project_key.key_name}.pem"
  content  = tls_private_key.project_key.private_key_pem
}


resource "aws_instance" "NetSPI-server-instance" {
  ami               = "ami-0b5eea76982371e91"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = aws_key_pair.project_key.key_name
  subnet_id         = aws_subnet.NetSPI-subnet.id
  security_groups   = [aws_security_group.NetSPI_SG.id]

}
#Associate EIP with EC2 Instance
resource "aws_eip_association" "demo-eip-association" {
  instance_id   = aws_instance.NetSPI-server-instance.id
  allocation_id = data.aws_eip.NetSPI_EIP.id

}

resource "null_resource" "configure_ssh" {
  depends_on = [aws_efs_mount_target.NetSPIefs,aws_instance.NetSPI-server-instance]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.project_key.private_key_pem
    host        = data.aws_eip.NetSPI_EIP.public_ip
  }

provisioner "remote-exec" {
  inline = [
    "sudo yum install nfs-utils -y",
    "sudo mkdir -p /data/test",
    "sudo chmod go+rw /data/test",
    "sudo mount -t nfs -o tls ${aws_efs_file_system.NetSPI-efs-volume.id}:/ /data/test",
    "sudo echo ${aws_efs_file_system.NetSPI-efs-volume.dns_name}:/ /data/test nfs4 defaults 0 0  >> /etc/fstab",
    
  ]
}
}