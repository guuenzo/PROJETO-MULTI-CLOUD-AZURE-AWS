resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidrblock_azure]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MULTICLOUD-SG"
  }
}

resource "aws_instance" "main_instance" {
  associate_public_ip_address = true
  ami                         = var.awslnx_ami
  subnet_id                   = aws_subnet.main_sub.id
  security_groups             = [aws_security_group.main_sg.id]
  instance_type               = "t2.micro"
  key_name                    = "vockey"
  tags = {
    Name = "INSTANCE-MULTICLOUD"
  }
}
