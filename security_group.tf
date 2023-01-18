resource "aws_security_group" "NetSPI_SG" {
  name        = "NetSPI_SG"
  description = "Allow all inbound to Port 22, Allow all outbound"
  vpc_id      = aws_vpc.NetSPI-vpc.id

ingress {
  description = "Allow all inbound to Port 22"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  description = "EFS mount target"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}