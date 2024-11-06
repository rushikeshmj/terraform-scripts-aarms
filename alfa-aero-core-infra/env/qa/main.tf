# QA environment module configuration that includes networking , S3, RDS, Elastic Beanstalk, WAF, and Bastion Host.

module "qa" {
    source                               = "../../modules"

    env                                  = var.env
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


    # S3
    source_backend_files                         = var.source_backend_files
    source_frontend_files                         = var.source_frontend_files

    # Database
    engine                               = var.engine
    engine_version                       = var.engine_version
    instance_class                       = var.instance_class
    username                             = var.username
    password                             = var.password
    family                               = var.family
    deletion_protection                  = var.deletion_protection
    final_snapshot_identifier            = var.final_snapshot_identifier

    # Elastic-Beanstalk
    solution_stack_name                  = var.solution_stack_name
    tier                                 = var.tier
    ssl_certificate_arn                  = var.ssl_certificate_arn

    # WAF
    scope                                = var.scope
    waf_rules                            = var.waf_rules
    custom_rules                         = var.custom_rules

    # RDS Bastion Host

    ami                                  = var.ami

    eip_allocation_id                    = var.eip_allocation_id

    # RDS WindowsInstance
 
    windows_ami                          = var.windows_ami
 
    eip_windows_allocation_id            = var.eip_windows_allocation_id

     # Providers
    providers = {
        aws = aws          # Default provider
        aws.us-east-1 = aws.us-east-1 # Aliased provider for WAF
    }


}

