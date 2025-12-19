# for easy pings & debug
output "instance_id" {
  value = aws_instance.hello.id
}

output "public_ip" {
  value = aws_instance.hello.public_ip
}