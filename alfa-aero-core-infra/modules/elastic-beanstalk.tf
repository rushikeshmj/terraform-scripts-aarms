# Create elastic beanstalk application
 
resource "aws_elastic_beanstalk_application" "elasticapp" {
  name                                 = "${var.env}-AARMS-API-APP"
  description                          = "Elastic Beanstalk application"

}
 
# Create elastic beanstalk Environment
resource "aws_elastic_beanstalk_environment" "beanstalkappenv" {
  name                                 = "${var.env}-AARMS-API-APP"
  application                          = aws_elastic_beanstalk_application.elasticapp.name
  solution_stack_name                  = var.solution_stack_name
  tier                                 = var.tier
  # version_label                        = aws_elastic_beanstalk_application_version.appversion.name
 
  setting {
    namespace                          = "aws:ec2:vpc"
    name                               = "VPCId"
    value                              = module.vpc.vpc_id
  }
  setting {
    namespace                          = "aws:autoscaling:launchconfiguration"
    name                               = "IamInstanceProfile"
    value                              = "${aws_iam_instance_profile.elastic_beanstalk_instance_profile.name}"
  }

  setting {
    namespace                          ="aws:autoscaling:launchconfiguration"
    name                               ="SecurityGroups"
    value                              = module.ec2_sg.security_group_id
  }

  setting {
    namespace                          = "aws:ec2:vpc"
    name                               = "AssociatePublicIpAddress"
    value                              =  "False"
  }
 
  setting {
    namespace                          = "aws:ec2:vpc"
    name                               = "Subnets"
    value                              = "${module.vpc.private_subnets[0]}, ${module.vpc.private_subnets[1]}"
  }

  setting {
    namespace                          = "aws:elasticbeanstalk:environment:process:default"
    name                               = "MatcherHTTPCode"
    value                              = "200"
  }
  setting {
    namespace                          = "aws:elasticbeanstalk:environment"
    name                               = "LoadBalancerType"
    value                              = "application"
  }
  setting {
    namespace                          = "aws:elasticbeanstalk:environment:process:default"
    name                               = "HealthCheckPath"
    value                              = "/api/Test"
  }
  setting {
    namespace                          = "aws:elbv2:listener:443"
    name                               = "Protocol"
    value                              = "HTTPS"
  }
  setting {
    namespace                          = "aws:elbv2:listener:443"
    name                               = "SSLCertificateArns"
    value                              = "arn:aws:acm:ca-central-1:192138073274:certificate/df9b6b81-d78a-43ea-a3ef-2d5f478f70bc"
  }
  setting {
    namespace                          = "aws:ec2:vpc"
    name                               = "ELBSubnets"
    value                              = join(",", module.vpc.public_subnets)
  }
  setting {
    namespace                          = "aws:elbv2:loadbalancer"
    name                               = "SecurityGroups"
    value                              = "${module.elastic_beanstalk_alb_sg.security_group_id}"
  }
  setting {
    namespace                          = "aws:autoscaling:launchconfiguration"
    name                               = "InstanceType"
    value                              = "t2.small"
  }
  setting {
    namespace                          = "aws:autoscaling:launchconfiguration"
    name                               = "DisableIMDSv1"
    value                              = "true"
  }
  setting {
    namespace                          = "aws:ec2:vpc"
    name                               = "ELBScheme"
    value                              = "public"
  }
  setting {
    namespace                          = "aws:autoscaling:asg"
    name                               = "MinSize"
    value                              = 1
  }
  setting {
    namespace                          = "aws:autoscaling:asg"
    name                               = "MaxSize"
    value                              = 1
  }
  setting {
    namespace                          = "aws:elbv2:loadbalancer"
    name                               = "IdleTimeout"
    value                              = "600"  # Set Idle Timeout to 600 seconds
  }
  setting {
    namespace                          = "aws:elasticbeanstalk:healthreporting:system"
    name                               = "SystemType"
    value                              = "enhanced"
  }
  setting {
    namespace                          = "aws:elasticbeanstalk:application:environment"
    name                               = "ASPNETCORE_ENVIRONMENT"
    value                              = "QA"
  }
  setting {
    namespace                          = "aws:elasticbeanstalk:managedactions:platformupdate"
    name                               = "UpdateLevel"
    value                              = "minor" 
  }   

  tags = {
      name                                = "${var.env}-AARMS-API-APP"
      environment                         = var.env
      "created by"                        = "terraform"
    }

  # lifecycle {
  #     ignore_changes = [setting]
  # }
}

# resource "aws_elastic_beanstalk_application_version" "appversion" {
#   name                                 = "${var.env}-alfa-aero-appversion"
#   application                          = aws_elastic_beanstalk_application.elasticapp.name
#   description                          = "Application Version created by Terraform for Alfa-Aero dotnet application"
#   bucket                               = module.s3-bucket-dotnet-application.s3_bucket_id
#   key                                  = aws_s3_object.upload-dotnet-application.key
# }
