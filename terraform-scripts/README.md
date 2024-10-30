# Terraform AWS Infrastructure for Alfa Aero

This repository contains a Terraform configuration for deploying a robust infrastructure on AWS for the Alfa Aero application. The setup includes the following components:

- **AWS Lambda**: A serverless compute service for running your code.
- **Amazon RDS**: A managed relational database service.
- **Amazon S3**: For storing VPC flow logs.
- **Virtual Private Cloud (VPC)**: For network isolation and security.
- **Security Groups**: For controlling inbound and outbound traffic.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Components](#components)
  - [Backend Configuration](#backend-configuration)
  - [Lambda Function](#lambda-function)
  - [RDS Configuration](#rds-configuration)
  - [S3 Bucket Configuration](#s3-bucket-configuration)
  - [VPC Configuration](#vpc-configuration)
  - [Security Groups](#security-groups)
- [Usage](#usage)
- [Outputs](#outputs)
- [Variables](#variables)

## Overview

The Terraform configuration utilizes multiple modules to provision an AWS infrastructure tailored to Alfa Aero's requirements. It allows for easy management of resources, scalability, and adherence to best practices.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version 1.0 or higher)
- An AWS account with permissions to create IAM roles, Lambda functions, RDS instances, S3 buckets, and VPCs.
- Configure AWS credentials using the AWS CLI or by setting environment variables.
- [tfsec](https://aquasecurity.github.io/tfsec/) installed for security scanning of Terraform code.

## Directory Structure

The directory structure of the repository is organized as follows:

    ├── backend.tf                # Configuration for the S3 backend to store Terraform state
    ├── demo.py                   # Sample AWS Lambda function code that prints "Hello World"
    ├── lambda.tf                 # Module configuration for provisioning the AWS Lambda function
    ├── output.tf                 # Output values for various resources created
    ├── provider.tf               # AWS provider configuration
    ├── rds.tf                    # Module configuration for provisioning an Amazon RDS instance
    ├── security-group.tf         # Security group configurations for the database and Lambda function
    ├── s3-vpc-flow-logs.tf       # Module configuration for creating an S3 bucket for VPC flow logs
    ├── terraform.tfvars          # Variables for customizing the infrastructure deployment
    ├── variables.tf              # Definition of input variables used in the Terraform configuration
    └── vpc.tf                    # Module configuration for provisioning a Virtual Private Cloud (VPC)

## Components

### Backend Configuration

The `backend.tf` file configures the S3 backend for storing the Terraform state file securely. The configuration uses encryption and a DynamoDB table for state locking.

### Lambda Function

The `demo.py` file contains a simple AWS Lambda function that prints "Hello World". The `lambda.tf` file configures the Lambda function's properties, such as the runtime, handler, and associated security groups.

### RDS Configuration

The `rds.tf` file provisions an Amazon RDS MySQL instance with specified configurations, including allocated storage, engine version, and security group associations.

### S3 Bucket Configuration

The `s3-vpc-flow-logs.tf` file creates an S3 bucket for storing VPC flow logs, with versioning enabled and a policy that allows for the deletion of non-empty buckets.

### VPC Configuration

The `vpc.tf` file provisions a Virtual Private Cloud (VPC) with public and private subnets, NAT gateways, and flow logs. This ensures a secure networking environment for the application.

### Security Groups

The `security-group.tf` file provisions security groups for the database and Lambda function, allowing for controlled inbound and outbound traffic based on specified rules.

## Usage

1. Clone this repository.
   ```bash
   git clone https://github.com/yourusername/alfa-aero-terraform.git
   cd alfa-aero-terraform

2. Initialize terraform.
   ```bash
   terraform init

3. Review the plan
    ```bash
   terraform plan

4. Apply the configuration to create the infrastructure.
   ```bash
   terraform apply

5. To destroy the infrastructure when no longer needed.
    ```bash
   terraform destroy

## Outputs

After successful deployment, the following output values will be displayed:

- **`vpc_id`**: ID of the created VPC.
- **`security_group_id`**: ID of the database security group.
- **`rds_endpoint`**: Endpoint of the RDS instance.
- **`s3_bucket_id`**: ID of the created S3 bucket.
- **`lambda_function_arn`**: ARN of the Lambda function.
- **`lambda_function_name`**: Name of the Lambda function.

## Variables

This Terraform configuration uses input variables to customize the deployment of the AWS infrastructure. You can configure various aspects such as the AWS region, VPC settings, RDS database details, and Lambda function properties by modifying the variables defined in the `variables.tf` file. 

To set specific values for these variables, use the `terraform.tfvars` file, where you can override the default values provided in `variables.tf` to suit your specific requirements.

## Security Scanning with tfsec

This repository uses [tfsec](https://aquasecurity.github.io/tfsec/) to perform static analysis security scanning of the Terraform code. tfsec checks for potential security issues by reviewing the Terraform configuration and highlighting any risks or best practice violations.

To run a security scan, execute the following command in the root directory of the repository:

```bash
tfsec .



# Alfa Aero Infrastructure with Terraform

This project uses Terraform to provision and manage infrastructure for **Alfa Aero** on AWS. It includes creating a Virtual Private Cloud (VPC), security groups for different services (EC2, Lambda, DB), and IAM roles with appropriate policies for Lambda and Elastic Beanstalk services.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) 0.13 or higher.
- AWS credentials configured via environment variables or AWS credentials file.
- IAM user with sufficient permissions for managing AWS resources.

## Infrastructure Components

### 1. VPC
- **VPC** with public and private subnets across multiple Availability Zones.
- Configurable CIDR block and subnets.

### 2. Security Groups
- Security groups for **EC2**, **Lambda**, and **Database** services with specific ingress/egress rules.

### 3. IAM Roles
- IAM roles for **Lambda** and **Elastic Beanstalk** with necessary policies for execution and resource access.

## Variables

Key variables that can be customized in `terraform.tfvars`:

- **region**: AWS region (e.g., `us-east-1`)
- **name**: Name of the VPC
- **cidr**: CIDR block for the VPC
- **azs**: List of availability zones
- **public_subnets**: Public subnet CIDR blocks
- **private_subnets**: Private subnet CIDR blocks
- **Security Group rules**: Configurable ingress/egress rules for EC2, Lambda, and Database.