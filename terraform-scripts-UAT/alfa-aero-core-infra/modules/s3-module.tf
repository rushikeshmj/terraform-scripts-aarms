# S3 Bucket for static website hosting.

module "s3-bucket-angular-application" {
    source = "terraform-aws-modules/s3-bucket/aws"
    version = "4.1.1"
 
    bucket                               = "${var.env}-alfa-aero-angular-application"
    acl                                  = "private"
    control_object_ownership             = true
    object_ownership                     = "ObjectWriter" # BucketOwnerPreferred for ownership to only bucket owner
    force_destroy                        = true         # Allow deletion of non-empty bucket

    versioning = {
        enabled = true
    }
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
    

    website = {
  index_document = "index.html"
  error_document = "error.html"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

    
    tags = {
    name         = "${var.env}-dotnet-application"
    environment  = var.env
    "created by" = "terraform"
  }
}

resource "aws_s3_bucket_cors_configuration" "s3-angular-cors" {
  bucket = module.s3-bucket-angular-application.s3_bucket_id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = ["http://${aws_cloudfront_distribution.cf-dist.domain_name}"]
    expose_headers  = []
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = []
    expose_headers = []
  }

  depends_on = [ module.s3-bucket-angular-application, aws_cloudfront_distribution.cf-dist]
}

// resource "aws_s3_object" "provision_source_files" {
//   bucket = module.s3-bucket-angular-application.s3_bucket_id

//   # webfiles/ is the Directory contains files to be uploaded to S3
//   for_each = fileset("${var.source_frontend_files}/", "**/*.*")

//   key          = each.value
//   source       = "${var.source_frontend_files}/${each.value}"
//   content_type = each.value
// }



data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3-bucket-angular-application.s3_bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cf-dist.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  bucket = module.s3-bucket-angular-application.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

# S3 bucket for backend .net application

module "s3-bucket-dotnet-application" {
    source = "terraform-aws-modules/s3-bucket/aws"
    version = "4.1.1"

    bucket                               = "${var.env}-alfa-aero-dotnet-application"
    acl                                  = "private"
    control_object_ownership             = true
    object_ownership                     = "ObjectWriter"
    force_destroy                        = true         # Allow deletion of non-empty bucket

    versioning = {
        enabled = true
    }
    server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256" 
      }
    }
  }
    tags = {
    name         = "${var.env}-dotnet-application"
    environment  = var.env
    "created by" = "terraform"
  }
}


// resource "aws_s3_object" "upload-dotnet-application" {
//     bucket = module.s3-bucket-dotnet-application.s3_bucket_id
//     #key           = "beanstalk/SampleApp.zip" # Specify the desired S3 key/path
//     key           = "beanstalk/${var.source_backend_files}"
//     #source        = "E:/Alfa-Aero Project/SampleApp.zip" # Specify the local file to upload
//     source        = var.source_backend_files

// }


# This module provisions an Amazon S3 bucket for storing VPC flow logs
module "s3-bucket-VPC-Flow-logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket                   = "${var.env}-alfa-aero-vpc-flow-logs"
  acl                      = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  force_destroy            = true # Allow deletion of non-empty bucket

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256" 
      }
    }
  }

  tags = {
    name         = "${var.env}-vpc-flow-logs"
    environment  = var.env
    "created by" = "terraform"
  }
}
