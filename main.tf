
module "vpc_us" {

  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr_us
  public_subnets      = var.vpc_us_pub_subnets
  private_subnets     = var.vpc_us_pvt_subnets
  availability_zones  = var.az_us
  sec_region_vpc_cidr = "10.1.0.0/16"
  transit_gateway_id  = module.tgw_us.transit_gateway_id
  name = "us-east"
  providers = {
    aws = aws.us
  }
}

locals {
  public_subnet_map = {
    for idx, id in module.vpc_us.public_subnets_id :
    "subnet-${idx + 1}" => id

  }
}


module "vpc_eu" {

  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr_eu
  public_subnets      = var.vpc_eu_pub_subnets
  private_subnets     = var.vpc_eu_pvt_subnets
  availability_zones  = var.az_eu
  sec_region_vpc_cidr = "10.0.0.0/16"
  transit_gateway_id  = module.tgw_eu.transit_gateway_id
  name                = "eu-west"
  providers = {
    aws = aws.eu
  }


}
locals {
  public_subnet_map_eu = {
    for idx, id in module.vpc_eu.public_subnets_id :
    "subnet-${idx + 1}" => id

  }
}

########### security group for application load balancer ##################

module "us-east-alb_sg" {

  source  = "./modules/security-group"
  sg_name = "us-east-alb"
  vpc_id  = module.vpc_us.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  providers = {
    aws = aws.us
  }

}


module "eu-west-alb_sg" {

  source  = "./modules/security-group"
  sg_name = "eu-west-alb"
  vpc_id  = module.vpc_eu.vpc_id

  ingress_rules = [
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  providers = {
    aws = aws.eu
  }

}

###############security group for web server ################
module "us-east-web_sg" {

  source  = "./modules/security-group"
  sg_name = "us-east-web"
  vpc_id  = module.vpc_us.vpc_id

  ingress_rules = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow ping"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  providers = {
    aws = aws.us
  }

}
module "eu-west-web_sg" {

  source  = "./modules/security-group"
  sg_name = "eu-west-web"
  vpc_id  = module.vpc_eu.vpc_id

  ingress_rules = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow ping"
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  ]
  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  providers = {
    aws = aws.eu
  }

}


########### Application load balancer ##################
module "alb_us" {
  source                = "./modules/load_balancer"
  name                  = "app_lb"
  vpc_id                = module.vpc_us.vpc_id
  security_groups       = [module.us-east-alb_sg.security_group_id]
  subnets               = module.vpc_us.public_subnets_id
  target_ids = module.us_instance.instances_ids
  health_check_path     = "/"
  health_check_interval = 30
  healthy_threshold     = 2
  unhealthy_threshold   = 2
  health_check_matcher  = "200-399"

  providers = {
    aws = aws.us
  }
}

module "alb_eu" {
  source = "./modules/load_balancer"

  name                  = "app_lb"
  vpc_id                = module.vpc_eu.vpc_id
  security_groups       = [module.eu-west-alb_sg.security_group_id]
  subnets               = module.vpc_eu.public_subnets_id
  target_ids = module.eu_instance.instances_ids
  health_check_path     = "/"
  health_check_interval = 30
  healthy_threshold     = 2
  unhealthy_threshold   = 2
  health_check_matcher  = "200-399"

  providers = {
    aws = aws.eu
  }
}

########### AWS Instances ##################

module "us_instance" {
  source = "./modules/ec2_instance"

  instance_type = "t2.micro"
  ssh_key_name  = var.key_name
  subnet_ids    = local.public_subnet_map
  private_sg_id = [module.us-east-web_sg.security_group_id]
  user_data     = file("user-data.sh")
  name          = "us-east-instance"

  providers = {
    aws = aws.us
  }
}



module "eu_instance" {
  source = "./modules/ec2_instance"

  instance_type = "t2.micro"
  ssh_key_name  = var.key_name_eu
  subnet_ids    = local.public_subnet_map_eu
  private_sg_id = [module.eu-west-web_sg.security_group_id]
  user_data     = file("user-data.sh")
  name          = "eu-west-instance"

  providers = {
    aws = aws.eu
  }
}

########### Transit Gateway ###

module "tgw_us" {

  source                = "./modules/transit-gateway"
  name                  = "us-east-"
  subnet_ids            = [module.vpc_us.public_subnets_id[0]]
  vpc_id                = module.vpc_us.vpc_id
  destination_vpc       = module.vpc_eu.vpc_cidr
  peering_attachment_id = module.tgw_peering_requester.peering_attachment_id

  providers = {
    aws = aws.us
  }
}


module "tgw_eu" {

  source                = "./modules/transit-gateway"
  name                  = "eu-west"
  subnet_ids            = [module.vpc_eu.public_subnets_id[0]]
  vpc_id                = module.vpc_eu.vpc_id
  destination_vpc       = module.vpc_us.vpc_cidr
  peering_attachment_id = module.tgw_peering_accepter.peering_attachment_id
  providers = {
    aws = aws.eu
  }
}


module "tgw_peering_requester" {

  source           = "./modules/tgw-peering_requester"
  requester_tgw_id = module.tgw_us.transit_gateway_id
  peer_twg_id      = module.tgw_eu.transit_gateway_id
  peer_region      = "eu-west-1"

  providers = {
    aws = aws.us
  }

}

module "tgw_peering_accepter" {

  source        = "./modules/tgw_peering_accepter"
  attachment_id = module.tgw_peering_requester.peering_attachment_id
  providers = {
    aws = aws.eu
  }

}

###############  VPC Logs ##############

module "vpc-flow-logs-us" {

  source = "./modules/vpc_cloudwatch"
  vpc_id = module.vpc_us.vpc_id
  name             = "vpc-logs-us"
 log_group_name   = "/aws/vpc/myproject-flow-logs-us"
  retention_in_days = 14
  traffic_type     = "ALL"

  tags = {
    Project = "VPC Monitoring"
    Environment = "dev"
  }
providers = {
    aws = aws.us
  }  

}

module "vpc-flow-logs-eu" {

  source = "./modules/vpc_cloudwatch"
  vpc_id = module.vpc_eu.vpc_id
  name             = "vpc-logs-eu"
 log_group_name   = "/aws/vpc/myproject-flow-logs-eu"
  retention_in_days = 14
  traffic_type     = "ALL"

  tags = {
    Project = "VPC Monitoring"
    Environment = "dev"
  }
providers = {
    aws = aws.eu
  }  

}

