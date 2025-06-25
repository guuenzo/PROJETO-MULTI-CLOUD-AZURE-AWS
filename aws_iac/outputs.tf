output "eip_main_instance" {
  value = aws_instance.main_instance.public_ip
}
