module "networking" {
  source    = "./modules/networking"
}

module "ec2_instance" {
  source    = "./modules/ec2-alb"
  vpc = module.networking.vpc
  public_subnet_id = module.networking.public_subnet_id
  private_subnet_id_2 = module.networking.private_subnet_id_2
  allow_http = module.networking.allow_http
  allow_https = module.networking.allow_https
  allow_ssh = module.networking.allow_ssh
}

module "db" {
  source = "./modules/rds"
  vpc = module.networking.vpc
  private_subnet_id = module.networking.private_subnet_id
  private_subnet_id_2 = module.networking.private_subnet_id_2
}
