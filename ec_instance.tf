provider "aws" {
  region  = "eu-west-1"
  # The profile picks from "./.aws/credentials"
  profile = "default"
  version = "4.54.0"
}

resource "aws_security_group" "allow_tls" {
  name        = "devops-chapter-sg"
  description = "Allow TLS inbound traffic"
  
  tags = {
    Name = "DevOps Chapter Security"
  }

  lifecycle {
    create_before_destroy = true
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform" {
  # This AMI already has Docker installed
  ami                    = "ami-0a3e7bbed76226241"
  instance_type          = "t2.micro"
  availability_zone      = "eu-west-1b"
  key_name               = "monitoring"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "chapter"
  }

  user_data = file("templates/docker.sh")
}
