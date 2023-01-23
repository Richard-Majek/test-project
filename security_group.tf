# create security group for the ec2 instance
resource "aws_security_group" "ssh_ec2_security_group" {
  name        = "ssh security group"
  description = "allow access on ports 22"
  vpc_id      = aws_default_vpc.default_vpc.id

  # allow access on port 22 ssh connection
  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "EFS mount target"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "my server security group"
  }
}