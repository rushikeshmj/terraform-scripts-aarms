# This is the resoruce creation for iam role, in this i have created for lambda and elastic beanstalk.

# Define the assume role policy document

# Create IAM Role for Elastic Beanstalk EC2 instances
data "aws_iam_policy_document" "assume_role_Elastic_Beanstalk_EC2" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create the IAM Role for Elastic Beanstalk using EC2
resource "aws_iam_role" "Elastic_Beanstalk_EC2_role" {
  name                               = "${var.env}-Alfa-Aero-Elastic-Beanstalk-EC2-Role"
  assume_role_policy                 =  data.aws_iam_policy_document.assume_role_Elastic_Beanstalk_EC2.json
}



# This is resource for attaching role with policy, I have created multiple roles and attached it with policy in this resource.

# Attach elastic beanstalk permissions to elastic beanstalk iam role

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_ec2_access" {
  role                                 = aws_iam_role.Elastic_Beanstalk_EC2_role.name
  policy_arn                           = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_ec2_basic" {
  role                                 = aws_iam_role.Elastic_Beanstalk_EC2_role.name
  policy_arn                           = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_ec2_core" {
  role                                 = aws_iam_role.Elastic_Beanstalk_EC2_role.name
  policy_arn                           = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

# Create instance profile
resource "aws_iam_instance_profile" "elastic_beanstalk_instance_profile" {
  name                                 = "elastic_beanstalk_instance_profile-1"
  role                                 = aws_iam_role.Elastic_Beanstalk_EC2_role.name
}
