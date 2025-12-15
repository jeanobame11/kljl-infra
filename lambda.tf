resource "aws_lambda_function" "api" {
  function_name = "fintech-api"
  runtime       = "java17"
  handler       = "com.fintech.Handler::handleRequest"
  role          = aws_iam_role.lambda.arn
  filename      = "build/fintech-api.jar"
  timeout       = 30
  memory_size   = 1024

  vpc_config {
    subnet_ids = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      DB_HOST       = aws_db_proxy.this.endpoint
      DB_NAME       = "fintech"
      DB_SECRET_ARN = aws_secretsmanager_secret.db.arn
    }
  }
}
