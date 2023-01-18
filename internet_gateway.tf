resource "aws_internet_gateway" "NetSPI_gw" {
  vpc_id = aws_vpc.NetSPI-vpc.id

  tags = {
    Project = "NetSPI"
  }
}