# Create IAM Role
resource "aws_iam_role" "ec2_admin_access_role" {
  name = "ec2_admin_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AdministratorAccess Policy to Role
resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  role       = aws_iam_role.ec2_admin_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # AWS built-in Administrator policy
}

# Create Instance Profile for the Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_admin_instance_profile"
  role = aws_iam_role.ec2_admin_access_role.name
}
