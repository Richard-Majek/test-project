# Create a Subnet
resource "aws_subnet" "NetSPI-subnet" {
  vpc_id            = aws_vpc.NetSPI-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
# Associate subnet with Route Table
resource "aws_route_table_association" "aws" {
  subnet_id      = aws_subnet.NetSPI-subnet.id
  route_table_id = aws_route_table.NetSPI-route-table.id
}