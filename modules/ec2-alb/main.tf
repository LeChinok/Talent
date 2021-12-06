resource "aws_instance" "for_user" {
  ami           = "ami-0a7559a0ef82639f2"
  instance_type = "t4g.micro"
  key_name               = "new-notes"
  vpc_security_group_ids = [var.allow_http, var.allow_https, var.allow_ssh]
  subnet_id              = var.public_subnet_id
  user_data = <<-EOF
              #!/bin/bash
              sudo apt install nginx
              EOF

  tags = {
    Name        = "For User"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_instance" "for_companies" {
  ami           = "ami-0a7559a0ef82639f2"
  instance_type = "t4g.micro"
  key_name               = "new-notes"
  vpc_security_group_ids = [var.allow_http, var.allow_https, var.allow_ssh]
  subnet_id              = var.public_subnet_id
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  tags = {
    Name        = "For Companies"
    Terraform   = "true"
    Environment = "dev"
  }
}

#Generating Key pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "new-notes"
  public_key = tls_private_key.this.public_key_openssh
}

#Application load balancer (I also got it to work with API Gateway)
resource "aws_lb" "myalb" {
  name               = "alb-instance"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.allow_http,var.allow_https]
  subnets            = [var.public_subnet_id, var.private_subnet_id_2]
  enable_deletion_protection = true
  idle_timeout                = 400
  
}
