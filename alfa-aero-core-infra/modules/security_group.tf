# This is security group module created for different services such as EC2, Lambda, Database and Elastic Beanstalk with the required ingress and egress required

# Security group for ec2 instance of elastic beanstalk
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name                                 = "${var.env}-Alfa-Aero-EC2-SG"
  description                          = "Security group for EC2-service with custom ports open within VPC"
  vpc_id                               = module.vpc.vpc_id
  

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = "${module.elastic_beanstalk_alb_sg.security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  depends_on = [ module.elastic_beanstalk_alb_sg ]
}

# Security group for RDS 
module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name                                 = "${var.env}-Alfa-Aero-DB-SG"
  description                          = "Security group for Database with custom ports open within VPC"
  vpc_id                               = module.vpc.vpc_id

computed_ingress_with_source_security_group_id = [
  {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.bastion_sg.security_group_id}"
  },
  {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.ec2_sg.security_group_id}"
  },
  {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.windows_sg.security_group_id}"
  }
]
number_of_computed_ingress_with_source_security_group_id = 3

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
tags = {
    name         = "${var.env}-AARMS-MySQL"
    environment  = var.env
    "created by" = "terraform"
  }
}

# Security group of elastic beanstalk ALB
module "elastic_beanstalk_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name                                 = "${var.env}-ALB-AARMS-API-APP"
  description                          = "Security group for Database with custom ports open within VPC"
  vpc_id                               = module.vpc.vpc_id

  ingress_with_cidr_blocks             = [
  {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
  }
]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    name         = "${var.env}-AARMS-API-APP"
    environment  = var.env
    "created by" = "terraform"
  }
}

# Security group for bastion host
module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name                                 = "${var.env}-Alfa-Aero-Bastion-SG"
  description                          = "Security group for Database Bastion Host with custom ports open within VPC"
  vpc_id                               = module.vpc.vpc_id

  ingress_with_cidr_blocks             = [
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb 4"
      cidr_blocks = "103.81.78.15/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "CT Public 7 - Gandhinagar"
      cidr_blocks = "14.140.153.130/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb-EON 2"
      cidr_blocks = "14.143.170.180/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = ""
      cidr_blocks = "108.171.87.73/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb-EON 1"
      cidr_blocks = "182.79.38.148/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb 6"
      cidr_blocks = "123.63.154.180/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "AASI - RLP - Ottawa"
      cidr_blocks = "70.51.135.85/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "AASI SPJL YOW"
      cidr_blocks = "198.84.232.169/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb 3"
      cidr_blocks = "103.81.79.35/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb 5"
      cidr_blocks = "103.81.78.10/32"
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Cyb 1"
      cidr_blocks = "103.81.79.15/32"
  }
]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    name         = "${var.env}-AARMS-API-APP"
    environment  = var.env
    "created by" = "terraform"
  }
  
}
# Security group for Windows Instance
module "windows_sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"
 
  name                                 = "${var.env}-Alfa-Aero-Skyvia-Agent-SG"
  description                          = "Security group for Database Windows Instance with custom ports open within VPC"
  vpc_id                               = module.vpc.vpc_id
 
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
 
  tags = {
    name         = "${var.env}-AARMS-API-APP"
    environment  = var.env
    "created by" = "terraform"
  }
 
}