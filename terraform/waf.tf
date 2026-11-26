resource "aws_wafv2_web_acl" "juice_shop" {
  name  = "${var.project_name}-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "aws-common-rules"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-waf-common"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = false
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_wafv2_web_acl_association" "juice_shop" {
  resource_arn = aws_lb.juice_shop.arn
  web_acl_arn  = aws_wafv2_web_acl.juice_shop.arn
}
