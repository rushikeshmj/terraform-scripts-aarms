# This module provisions an Bastion Host(EC2) for secure connection.

module "bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                                 = "${var.env}-alfa-aero-rds-bastion-host"
  ami                                  = var.ami 
  instance_type                        = "t2.micro"
  monitoring                           = true
  vpc_security_group_ids               = [module.bastion_sg.security_group_id]
  subnet_id                            = module.vpc.public_subnets[0]
  key_name                             = "qa-env-key"

  tags = {
    name         = "${var.env}-AARMS-API-APP"
    environment  = var.env
    "created by" = "terraform"
  }
}

resource "aws_eip_association" "bastion_host_eip" {
  instance_id   = module.bastion_host.id
  allocation_id = var.eip_allocation_id

}
