resource "aws_db_subnet_group" "db_subnets" {
  name       = "kljl-app-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "kljl-app-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "kljl-app-mysql-db"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"

  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.app.id]

  skip_final_snapshot = true
}
