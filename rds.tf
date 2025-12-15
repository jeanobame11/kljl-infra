resource "aws_db_subnet_group" "db_subnets" {
  name = "kljl-app-db-subnet-group"

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

  db_name  = "fintech"  

  
  // TODO: Password should be stored securely, e.g., in AWS Secrets Manager
  username = var.db_username
  password             = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.app.id]

  skip_final_snapshot = true
}

resource "aws_db_proxy" "this" {
  name          = "fintech-rds-proxy"
  engine_family = "MYSQL"
  role_arn      = aws_iam_role.rds_proxy.arn
  vpc_subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.db.arn
  }
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name
}

resource "aws_db_proxy_target" "this" {
  db_proxy_name         = aws_db_proxy.this.name
  target_group_name    = aws_db_proxy_default_target_group.this.name
  db_instance_identifier = aws_db_instance.mysql.id
}

