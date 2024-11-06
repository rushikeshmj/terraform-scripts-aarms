# Terraform input variable definitions for configuring AWS infrastructure components. These variables specify the configuration for VPC, RDS, and other AWS resources.

# Define the environment name (e.g., dev, staging, production)
variable "env" {
  type        = string
  description = "Environment name"
}

# Specified variables for VPC module including name, CIDR block, availability zones, 
# subnet configurations (public, private), NAT gateway settings, 
# ACL rules for managing inbound and outbound traffic.

variable "cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single NAT gateway"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map public IP on launch"
}

variable "public_inbound_acl_rules" {
  type        = list(map(string))
  description = "Public inbound ACL rules"
}

variable "public_outbound_acl_rules" {
  type        = list(map(string))
  description = "Public outbound ACL rules"
}

variable "private_inbound_acl_rules" {
  type        = list(map(string))
  description = "Private inbound ACL rules"
}

variable "private_outbound_acl_rules" {
  type        = list(map(string))
  description = "Private outbound ACL rules"
}

# # Variables for configuring S3 bucket settings, including the primary bucket name, failover bucket name.
variable "source_frontend_files" {
    description = "The path where index.html is located"
    type = string
}

variable "source_backend_files" {
    description = "Backend dotnet files path"
    type = string
}


# Variables for configuring Amazon RDS.

variable "username" {
  type        = string
  description = "Database username"
}

variable "password" {
  type        = string
  description = "Database password"
}

variable "engine" {
  description = "The database engine."
}

variable "engine_version" {
  description = "The version of the database engine."
}

variable "instance_class" {
  description = "The instance type for the RDS instance."
}

variable "family" {
  description = "The database engine family for the RDS instance. This specifies the type of database engine"
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection."
  type        = bool
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  type        = string
}

# Variables for Elastic-Beanstalk application.

variable "solution_stack_name" {
  type        = string
  description = "Elastic Beanstalk solution stack name"
}

variable "tier" {
  type        = string
  description = "Elastic Beanstalk environment tier"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "SSL Certificate ARN"
}

# Variables for configuring WAF.
variable "scope" {
  description = "Scope for waf"
  type = string
}

variable "waf_rules" {
  description = "List of WAF rules to be applied"
  type = list(object({
    name      = string
    priority  = number
    vendor    = string
    rule_name = string
    metric    = string
  }))
}

variable "custom_rules" {
  description = "Custom WAF rules for blocking specific URLs"
  type = list(object({
    name             = string
    priority         = number
    statements       = list(object({
      search_string   = string
      field_to_match  = string
      transformation  = string
      positional_constraint = string
    }))
    metric_name      = string
  }))
}

# RDS Bashion Host

variable "ami" {
  description = "Machine Image ID"
  type        = string
}

variable "eip_allocation_id" {
  description = "Elastic IP Allocation ID"
  type        = string
}

# RDS Windows Instance
 
variable "windows_ami" {
  description = "Machine Image ID"
  type        = string
}
 
variable "eip_windows_allocation_id" {
  description = "Elastic IP Allocation ID"
  type        = string
}
