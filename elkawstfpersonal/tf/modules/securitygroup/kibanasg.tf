# kibana security group
resource "aws_security_group" "kibana_sg" {
  vpc_id = var.vpc_id
  ingress {
    description = "Allow all inbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "tcp"
    to_port     = 65535
  }
  ingress {
    description = "ingress rules"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
  ingress {
    description = "ingress rules"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5601
    protocol    = "tcp"
    to_port     = 5601
  }
  egress {
    description = "egress rules"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  tags = {
    Name = "kibana_security_group"
  }
}
