output "vpc" {
  value = module.vpc
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_subnet_2.id
}

output "allow_http" {
  value = aws_security_group.allow_http.id
}

output "allow_https" {
  value = aws_security_group.allow_https.id
}

output "allow_ssh" {
  value = aws_security_group.allow_ssh.id
}