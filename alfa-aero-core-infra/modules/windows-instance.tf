# This module provisions an Bastion Host(EC2) for secure connection.
 
module "windows_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
 
  name                                 = "${var.env}-alfa-aero-skyvia-agent"
  ami                                  = var.windows_ami
  instance_type                        = "t3.medium"
  monitoring                           = true
  vpc_security_group_ids               = [module.windows_sg.security_group_id]
  subnet_id                            = module.vpc.public_subnets[0]
  key_name                             = "uat-env-key"
 
  tags = {
    name         = "${var.env}-AARMS-API-APP"
    environment  = var.env
    "created by" = "terraform"
  }
}
 
resource "aws_eip_association" "windows_bastion_host_eip" {
  instance_id   = module.windows_instance.id
  allocation_id = var.eip_windows_allocation_id
 
}