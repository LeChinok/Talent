module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Infra"
  cidr = "10.0.0.0/16"

  azs  = ["eu-central-1a", "eu-central-1b"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "igw-infra"
  }
}

resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "rtb-private-infra"
  }
}

resource "aws_subnet" "private_subnet" {
  availability_zone = "eu-central-1a"
  cidr_block = "10.0.1.0/24"
  vpc_id = module.vpc.vpc_id
  tags = {
    Environment = "Prod"
    Name = "Infra-Private-Subnet"
  }
}

resource "aws_subnet" "private_subnet_2" {
  availability_zone = "eu-central-1b"
  cidr_block = "10.0.201.0/24"
  vpc_id = module.vpc.vpc_id
  tags = {
    Environment = "Prod"
    Name = "Infra-Private-Subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  availability_zone = "eu-central-1a"
  cidr_block = "10.0.101.0/24"
  vpc_id = module.vpc.vpc_id
  tags = {
    Environment = "Prod"
    Name = "Infra-Public-Subnet"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rtb-public-infra"
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "allow_http" {
  description = "Allow HTTP inbound traffic"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
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
    Name = "Allow HTTP"
  }
}

resource "aws_security_group" "allow_https" {
  description = "Allow HTTPS inbound traffic"
  vpc_id = module.vpc.vpc_id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "Allow HTTPS"
  }
}

resource "aws_security_group" "allow_ssh" {
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from the internet"
    from_port   = 22
    to_port     = 22
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
    Name = "Allow SSH"
  }
}