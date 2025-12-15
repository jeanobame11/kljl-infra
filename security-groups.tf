resource "aws_security_group" "app" {
  name   = "kljl-app-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
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
    Name = "kljl-app-app-sg"
  }
}

resource "aws_security_group" "rds" {
  name   = "kljl-app-rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kljl-app-rds-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "kljl-ec2-sg"
  vpc_id = aws_vpc.main.id

  # allow SSH from your laptop
  ingress {
    description = "SSH from my laptop"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["67.176.13.144/32"]
  }

  # allow all outbound (needed to reach RDS)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kljl-ec2-sg"
  }
}

resource "aws_security_group" "lambda" {
  name   = "kljl-lambda-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "rds_proxy" {
  name   = "kljl-rds-proxy-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "lambda_to_proxy" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id         = aws_security_group.lambda.id
  source_security_group_id  = aws_security_group.rds_proxy.id
}

resource "aws_security_group_rule" "proxy_from_lambda" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id         = aws_security_group.rds_proxy.id
  source_security_group_id  = aws_security_group.lambda.id
}

