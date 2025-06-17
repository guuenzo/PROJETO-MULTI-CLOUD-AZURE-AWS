resource "aws_vpc" "main_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "VPC-MULTICLOUD"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "IGW-MULTICLOUD"
  }
}

resource "aws_subnet" "main_priv_sub" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "172.16.0.0/24"
  tags = {
    Name = "PRIV-SUB-MULTICLOUD"
  }
}

resource "aws_route_table" "main_priv_rtb" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MULTICLOUD-RTB"
  }
}

resource "aws_route_table_association" "main_priv_association" {
  subnet_id      = aws_subnet.main_priv_sub.id
  route_table_id = aws_route_table.main_priv_rtb.id
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.main_priv_rtb.id
  gateway_id             = aws_internet_gateway.main_igw.id
  destination_cidr_block = "0.0.0.0/0"
}