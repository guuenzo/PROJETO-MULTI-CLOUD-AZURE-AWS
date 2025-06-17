output "main_instance_eip" {
  value = aws_instance.main_instance.public_ip
}