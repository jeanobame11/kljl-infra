resource "aws_secretsmanager_secret" "db" {
  name = "fintech-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
