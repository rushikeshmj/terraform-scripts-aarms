# This module provisions an Amazon RDS MySQL instance
module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.9.0"

  name                                 = "${var.env}-aarms-dbs-instance"
  engine                               = var.engine
  engine_version                       = var.engine_version
  instance_class                       = var.instance_class
  snapshot_identifier                  = "arn:aws:rds:ca-central-1:192138073274:cluster-snapshot:rds:database-demo-2024-10-29-04-54"
  instances = {
    one = {
      instance_class                   = "${var.instance_class}"
      priority                         = 1
      failover                         = true
      promotion_tier                   = 1
    }
}

  master_username                      = var.username
  manage_master_user_password          = false
  master_password                      = var.password
  allow_major_version_upgrade          = true
  create_security_group                = false
  vpc_security_group_ids               = [module.db_sg.security_group_id]
  storage_encrypted                    = true

  availability_zones                   = [module.vpc.azs[0], module.vpc.azs[1], module.vpc.azs[2]]
  skip_final_snapshot                  = false
  final_snapshot_identifier            = "${var.env}-${var.final_snapshot_identifier}"
  create_db_subnet_group               = true
  subnets                              = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  deletion_protection                  = var.deletion_protection
  publicly_accessible                  = false
  backup_retention_period              = 3
  iam_database_authentication_enabled  = true
  enabled_cloudwatch_logs_exports      = ["audit", "slowquery"]
  monitoring_role_arn                  = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  monitoring_interval                  = 60
  db_parameter_group_name              = "default.aurora-mysql8.0"

 tags = {
    name         = "${var.env}-mysql-rds"
    environment  = var.env
    "created by" = "terraform"
  }
}
