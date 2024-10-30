# This Terraform configuration specifies the backend for storing the Terraform state.
terraform {
  backend "s3" {
    bucket = "uat-env-alfa-aero-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    # dynamodb_table = "alfa-aero-terraform-state-lock"
    # encrypt        = true
  }
}
