data "aws_s3_bucket" "selected_bucket" {
  bucket = module.s3-bucket-angular-application.s3_bucket_id
}


# Create AWS Cloudfront distribution
resource "aws_cloudfront_origin_access_control" "cf-s3-oac" {
  name                              = "CloudFront S3 OAC"
  description                       = "CloudFront S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cf-dist" {
  # aliases             = ["0001.alfaaero.com", "0010-uat.alfaaero.com", "0024-uat.alfaaero.com", "0037-sb.alfaaero.com", "0042-sb.alfaaero.com"]
  aliases             = ["0001-uatcopy.alfaaero.com", "0010-uatcopy.alfaaero.com", "0024-uatcopy.alfaaero.com", "0037-sbcopy.alfaaero.com", "0042-sbcopy.alfaaero.com"]
  enabled             = true
  default_root_object = "index.html"
  comment = "${var.env}" 

  origin {
    domain_name              = data.aws_s3_bucket.selected_bucket.bucket_regional_domain_name
    origin_id                = module.s3-bucket-angular-application.s3_bucket_id
    origin_access_control_id = aws_cloudfront_origin_access_control.cf-s3-oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.s3-bucket-angular-application.s3_bucket_id
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    compress         = true
  }

  # Custom error responses for 403 and 404
  custom_error_response {
    error_code            = 403
    response_page_path    = "/index.html"    # Path to your custom 403 error page
    response_code         = 403
    error_caching_min_ttl = 10                   # Cache TTL for error response (optional)
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"    # Path to your custom 404 error page
    response_code         = 404
    error_caching_min_ttl = 10                   # Cache TTL for error response (optional)
  }

  web_acl_id = aws_wafv2_web_acl.cloudfront-waf.arn
  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true #2
    acm_certificate_arn = "arn:aws:acm:us-east-1:192138073274:certificate/4938aca2-452c-4847-bce8-fe063edbf4a0"
    ssl_support_method = "sni-only"
    minimum_protocol_version  = "TLSv1.2_2021"
  }


  tags = {
    name         = "${var.env}-cloudfront"
    environment  = var.env
    "created by" = "terraform"
  }
}

# Cloudfront Invalidations

resource "null_resource" "cf_invalidation" {
  provisioner "local-exec" {
    command = <<-EOF
      aws cloudfront create-invalidation \
        --distribution-id ${aws_cloudfront_distribution.cf-dist.id} \
        --region us-east-1 \
        --paths '/*.ts' \
          '/assets/i18n/help/fr.json' \
          '/assets/i18n/help/en.json' \
          '/assets/i18n/reporting/fr.json' \
          '/assets/i18n/home/en.json' \
          '/assets/i18n/recharge/en.json' \
          '/assets/i18n/customer/fr.json' \
          '/assets/i18n/database/fr.json' \
          '/*.html' \
          '/assets/i18n/tools/fr.json' \
          '/assets/i18n/statistics/en.json' \
          '/assets/i18n/statistics/fr.json' \
          '/index.html' \
          '/assets/i18n/recharge/fr.json' \
          '/assets/i18n/home/fr.json' \
    EOF
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
