output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_a_subnet_id" {
  value = aws_subnet.public_a.id
}

output "public_b_subnet_id" {
  value = aws_subnet.public_b.id
}

output "private_a_subnet_id" {
  value = aws_subnet.private_a.id
}

output "private_b_subnet_id" {
  value = aws_subnet.private_b.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

