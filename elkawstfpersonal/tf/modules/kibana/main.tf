resource "aws_instance" "kibana_instance" {

  ami           = "ami-047126e50991d067b"
  instance_type = "t2.medium"
  key_name      = "tfkey"
  # monitoring             = true
  vpc_security_group_ids = [var.kibana_sg_id]
  # subnet_id                   = var.subnet_ids[count.index]
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = true

  # user_data = file("${path.module}/../../scripts/kibana/kibana_startup.sh")

  iam_instance_profile = var.aws_iam_instance_profile_name

  connection {
    type        = "ssh"
    user        = "ubuntu" # Adjust according to your server
    private_key = file("~/.ssh/tfkey")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'start sleeping for 20 seconds'",
      "sleep 20",
      "sudo apt-get update && sudo apt-get install -y wget gnupg",
      "sleep 20",
      "wget https://artifacts.elastic.co/downloads/kibana/kibana-8.16.1-amd64.deb",
      "shasum -a 512 kibana-8.16.1-amd64.deb",
      "sudo dpkg -i kibana-8.16.1-amd64.deb",
      "sudo apt-get update && sudo apt-get install -y kibana",
      "echo 'server.port: 5601' | sudo tee -a /etc/kibana/kibana.yml",
      "echo 'server.host: \"0.0.0.0\"' | sudo tee -a /etc/kibana/kibana.yml",
      "echo 'elasticsearch.hosts: [\"http://${var.elasticsearch_private_ip}:9200\"]' | sudo tee -a /etc/kibana/kibana.yml",
      "sudo /bin/systemctl daemon-reload",
      "sudo /bin/systemctl enable kibana.service",
      "sudo systemctl start kibana.service"
    ]
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Type        = "kibana"
    Name        = "kibana-instance"
  }
}

# resource "local_file" "kibana_config" {
#   content = <<EOT
#   server.port: 5601
#   server.host: "0.0.0.0"
#   elasticsearch.hosts: ["http://${var.elasticsearch_private_ip}:9200"]
#   EOT
#   filename = "/tmp/kibana.yml"
# }
