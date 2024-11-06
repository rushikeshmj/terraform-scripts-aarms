# This module provisions an Amazon VPC along with its associated resources 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.12.1"

  name                                 = "${var.env}-alfa-aero-vpc"
  cidr                                 = var.cidr
  azs                                  = var.azs
  private_subnets                      = var.private_subnets
  public_subnets                       = var.public_subnets
  enable_nat_gateway                   = var.enable_nat_gateway
  single_nat_gateway                   = var.single_nat_gateway
  map_public_ip_on_launch              = var.map_public_ip_on_launch
  public_inbound_acl_rules             = var.public_inbound_acl_rules
  public_outbound_acl_rules            = var.public_outbound_acl_rules
  private_inbound_acl_rules            = var.private_inbound_acl_rules
  private_outbound_acl_rules           = var.private_outbound_acl_rules
  enable_flow_log                      = true
  flow_log_destination_type            = "s3"
  flow_log_destination_arn             = module.s3-bucket-VPC-Flow-logs.s3_bucket_arn

  vpc_flow_log_tags = {
    Name = "${var.env}-vpc-flow-logs-s3-bucket"
  }

  tags = {
    name         = "${var.env}-AARMS-VPC"
    environment  = var.env
    "created by" = "terraform"
  }

  depends_on = [module.s3-bucket-VPC-Flow-logs]
}