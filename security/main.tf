provider "aws" {
  region = var.region
}

module "network" {
  source = "./network"
}

module "security" {
  source = "./security"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source          = "./compute"
  publicSubnetA   = module.network.publicSubnetA
  BastionSG       = module.security.BastionSG
}