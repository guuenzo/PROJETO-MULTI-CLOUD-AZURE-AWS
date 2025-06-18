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

resource "aws_vpn_gateway" "main_vgw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "VGW-MULTICLOUD"
  }
}

resource "aws_route" "route_vgw" {
  route_table_id         = aws_route_table.main_priv_rtb.id
  gateway_id             = aws_vpn_gateway.main_vgw.id
  destination_cidr_block = "10.0.0.0/16"
}

resource "aws_customer_gateway" "main_cgw" {
  ip_address = var.cgw_ip
  bgp_asn    = "65000"
  type       = "ipsec.1"
  tags = {
    Name = "CGW-MULTICLOUD"
  }
}

resource "aws_vpn_connection" "main_vpn_conn" {
  type                = "ipsec.1"
  vpn_gateway_id      = aws_vpn_gateway.main_vgw.id
  customer_gateway_id = aws_customer_gateway.main_cgw.id
  static_routes_only  = true
}

resource "aws_vpn_gateway_route_propagation" "propagation" {
  vpn_gateway_id = aws_vpn_gateway.main_vgw.id
  route_table_id = aws_route_table.main_priv_rtb.id
}