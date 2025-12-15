resource "aws_instance" "db_tester" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "kljl-key" 
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y mariadb
              EOF

  tags = {
    Name = "rds-test-ec2"
  }
}
