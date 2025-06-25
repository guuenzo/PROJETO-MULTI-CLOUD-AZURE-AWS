resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPC-MULTICLOUD"
  }
}

resource "aws_subnet" "main_sub" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "SUB-MULTICLOUD"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "IGW-MULTICLOUD"
  }
}

resource "aws_route_table" "main_rtb" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "MULTICLOUD-RTB"
  }
}

resource "aws_route_table_association" "association" {
  route_table_id = aws_route_table.main_rtb.id
  subnet_id      = aws_subnet.main_sub.id
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.main_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_customer_gateway" "main_cgw" {
  ip_address = var.cgw_ip
  bgp_asn    = 65000
  tags = {
    Name = "CGW-MULTICLOUD"
  }
  type = "ipsec.1"
}

resource "aws_vpn_gateway" "main_vgw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "VGW-MULTICLOUD"
  }
}

resource "aws_vpn_connection" "main_conn" {
  type                    = "ipsec.1"
  customer_gateway_id     = aws_customer_gateway.main_cgw.id
  vpn_gateway_id          = aws_vpn_gateway.main_vgw.id
  outside_ip_address_type = "PublicIpv4"
  static_routes_only      = true
  tags = {
    Name = "CONN-MULTICLOUD"
  }
}

resource "aws_vpn_connection_route" "route_to_azure_sub" {
  vpn_connection_id      = aws_vpn_connection.main_conn.id
  destination_cidr_block = var.cidrblock_azure
}

resource "aws_vpn_gateway_route_propagation" "propagation" {
  route_table_id = aws_route_table.main_rtb.id
  vpn_gateway_id = aws_vpn_gateway.main_vgw.id
}
