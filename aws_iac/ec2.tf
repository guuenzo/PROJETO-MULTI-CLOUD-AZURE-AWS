resource "aws_security_group" "main_sg" {
  name = "MULTICLOUD-SG"
  vpc_id = aws_vpc.main_vpc.id 
  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main_instance" {
  key_name = "vockey"
  subnet_id                   = aws_subnet.main_priv_sub.id
  associate_public_ip_address = true
  ami                         = "ami-09e6f87a47903347c"
  instance_type               = "t2.micro"
  security_groups = [ aws_security_group.main_sg.id ]
  tags = {
    Name = "MULTICLOUD-EC2"
  }
}