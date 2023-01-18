# Create Custom Route Table
resource "aws_route_table" "NetSPI-route-table" {
  vpc_id = aws_vpc.NetSPI-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.NetSPI_gw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.NetSPI_gw.id
  }
}
