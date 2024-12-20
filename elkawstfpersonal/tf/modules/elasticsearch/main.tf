resource "aws_instance" "elasticsearch_instance" {
  ami           = "ami-047126e50991d067b"
  instance_type = "t2.medium"
  key_name      = "tfkey"
  # monitoring             = true
  vpc_security_group_ids = [var.elasticsearch_sg_id]
  # subnet_id                   = var.subnet_ids[count.index]
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = true

  user_data = file("${path.module}/../../scripts/elasticsearch/install_elasticsearch.sh")

  iam_instance_profile = var.aws_iam_instance_profile_name

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Type        = "elasticsearch"
    Name        = "elasticsearch-instance"

  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "tfkey"
  public_key = file("~/.ssh/tfkey.pub")
}