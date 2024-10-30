# This resource is used to provision WAF

resource "aws_wafv2_web_acl" "cloudfront-waf" {
  name        = "${var.env}-Alfa-Aero-cloudfront-waf"
  provider    = aws.us-east-1
  description = "WAF with managed and custom rules for CDN"
  scope       = "CLOUDFRONT"  # Change to CLOUDFRONT if needed
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "default-waf"
    sampled_requests_enabled   = true
  }
 
  # Dynamic block for managed rule groups
  dynamic "rule" {
    for_each = var.waf_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      statement {
        managed_rule_group_statement {
          vendor_name = rule.value.vendor
          name        = rule.value.rule_name
        }
      }
      override_action {
        none {}
      }
      visibility_config {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric
      }
    }
  }
 
  # Dynamic block for custom block rules
  dynamic "rule" {
    for_each = var.custom_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority
      statement {
        or_statement {
          dynamic "statement" {
            for_each = rule.value.statements
            content {
              byte_match_statement {
                search_string = statement.value.search_string
                field_to_match {
                  uri_path {} # We're using uri_path for all, but you can modify for dynamic fields
                }
                text_transformation {
                  priority = 0
                  type     = statement.value.transformation
                }
                positional_constraint = statement.value.positional_constraint
              }
            }
          }
        }
      }
      action {
        block {}
      }
      visibility_config {
        sampled_requests_enabled   = true
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.metric_name
      }
    }
  }

  tags = {
    name         = "${var.env}-AARMS-WAF"
    environment  = var.env
    "created by" = "terraform"
  }
}