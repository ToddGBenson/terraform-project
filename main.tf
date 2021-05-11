provider "aws" {
  region = var.region
  profile = "security"
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
  appA            = module.network.appA
  appB            = module.network.appB
  appC            = module.network.appC
  BastionSG       = module.security.BastionSG
  AppSG           = module.security.AppSG
}

module "containers" {
  source          = "./containers"
  ecsServiceRole  = module.security.ecsServiceRole
  myLabKeyPair    = module.containers.myLabKeyPair
  appA            = module.network.appA
  appB            = module.network.appB
  appC            = module.network.appC
  EcsSG           = module.security.EcsSG
  ecsExecutionRoleArn  = module.security.ecsExecutionRoleArn
  ecsInstanceProfileId = module.security.EcsInstanceProfileId
  KoffeeLuvTGArn  = module.network.KoffeeLuvTGArn
  KoffeeLuvAlbName = module.network.KoffeeLuvAlbName
}