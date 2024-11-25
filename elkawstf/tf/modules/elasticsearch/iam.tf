resource "aws_iam_role" "elastic_ec2_role" {
  name = "elastic-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "elastic_ec2_instance_profile" {
  name = "elastic-ec2-instance-profile"
  role = aws_iam_role.elastic_ec2_role.name
}
