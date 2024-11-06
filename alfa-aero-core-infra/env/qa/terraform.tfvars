# Terraform variable values for Alfa Aero's AWS infrastructure setup. This file contains the actual values used for configuring the VPC, subnets, RDS, S3.


# Variables assignment for AWS region & environment type used in terraform configuration.
region = "ca-central-1"

env = "qa-env"

# Variables assignment for VPC modules.

cidr = "10.0.0.0/16"

azs = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]

private_subnets = ["10.0.1.0/24", "10.0.3.0/24", "10.0.4.0/24"]

public_subnets = ["10.0.0.0/24", "10.0.2.0/24", "10.0.5.0/24"]

enable_nat_gateway = true

single_nat_gateway = true

map_public_ip_on_launch = true

public_inbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 443, "protocol" : "tcp", "rule_action" : "allow", "rule_number" : 100, "to_port" : 443 }]

public_outbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 443, "protocol" : "tcp", "rule_action" : "allow", "rule_number" : 101, "to_port" : 443 }]

private_inbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 443, "protocol" : "tcp", "rule_action" : "allow", "rule_number" : 102, "to_port" : 443 }]

private_outbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 443, "protocol" : "tcp", "rule_action" : "allow", "rule_number" : 103, "to_port" : 443 }]



# Variables assignment for S3

#source_files                    = "E:/Alfa-Aero Project/terraform-aws-cloudfront-s3/webfiles"
source_frontend_files                    = "AARMS/Web/AASI.AARMS.WEB/ClientApp"

source_backend_files                     = "AARMS/Services/AASI.AARMS.API"



# Variables assignment for RDS.

engine = "aurora-mysql"

engine_version = "8.0.mysql_aurora.3.07.1"

instance_class = "db.t3.medium"

username = "admin"

password = "Pa$$w0rd123"

family = "aurora-mysql8.0"

deletion_protection = false

final_snapshot_identifier = "aarms-dbs-instance-snapshot"

# Variables for Elastic Beanstalk Application.

solution_stack_name = "64bit Amazon Linux 2 v2.8.2 running .NET Core"  # Updated Stack name

tier = "WebServer"

ssl_certificate_arn  = "arn:aws:acm:ca-central-1:192138073274:certificate/df9b6b81-d78a-43ea-a3ef-2d5f478f70bc"

# Variables for WAF

scope                           = "CLOUDFRONT"

waf_rules = [
  {
    name      = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority  = 0
    vendor    = "AWS"
    rule_name = "AWSManagedRulesAmazonIpReputationList"
    metric    = "AWS-AWSManagedRulesAmazonIpReputationList"
  },
  {
    name      = "AWS-AWSManagedRulesCommonRuleSet"
    priority  = 1
    vendor    = "AWS"
    rule_name = "AWSManagedRulesCommonRuleSet"
    metric    = "AWS-AWSManagedRulesCommonRuleSet"
  },
  {
    name      = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority  = 2
    vendor    = "AWS"
    rule_name = "AWSManagedRulesKnownBadInputsRuleSet"
    metric    = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
  },
  {
    name      = "AWS-AWSManagedRulesAnonymousIpList"
    priority  = 3
    vendor    = "AWS"
    rule_name = "AWSManagedRulesAnonymousIpList"
    metric    = "AWS-AWSManagedRulesAnonymousIpList"
  },
  {
    name      = "AWS-AWSManagedRulesBotControlRuleSet"
    priority  = 4
    vendor    = "AWS"
    rule_name = "AWSManagedRulesBotControlRuleSet"
    metric    = "AWS-AWSManagedRulesBotControlRuleSet"
  }
]

custom_rules = [
  {
    name       = "Block_Anonymous_URLs"
    priority   = 5
    statements = [
      {
        search_string        = ".env"
        field_to_match       = "uri_path"
        transformation       = "LOWERCASE"
        positional_constraint = "CONTAINS"
      },
      {
        search_string        = "server"
        field_to_match       = "uri_path"
        transformation       = "LOWERCASE"
        positional_constraint = "CONTAINS"
      },
      {
        search_string        = "php"
        field_to_match       = "uri_path"
        transformation       = "LOWERCASE"
        positional_constraint = "CONTAINS"
      }
    ]
    metric_name = "Block_Anonymous_URLs"
  }
]

# RDS Bashion Host
ami                             = "ami-049332278e728bdb7"

eip_allocation_id               = "eipalloc-0d7c7d203239adbd0"

# RDS Windows Instance
windows_ami                     = "ami-0bfd2dd93f0dc6a8b"
 
eip_windows_allocation_id       = "eipalloc-0d552b85529528e11"