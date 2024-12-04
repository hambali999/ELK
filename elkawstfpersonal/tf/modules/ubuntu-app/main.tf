resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.logstash_sg_id]
  subnet_id                   = var.subnet_ids[0]
  associate_public_ip_address = true
  iam_instance_profile        = var.aws_iam_instance_profile_name

  # Use templatefile to inject the variable into the user_data script
  # user_data = templatefile("${path.module}/logstash_user_data.sh", {
  #   elasticsearch_ip = var.elasticsearch_private_ip
  # })

  tags = merge(var.default_tags, { Name = var.instance_name })

  connection {
    type        = "ssh"
    user        = "ubuntu" # Adjust according to your server
    private_key = file("~/.ssh/tfkey")
    host        = self.public_ip
  }
  
  provisioner "file" {
    source      = "${path.module}/logstash_user_data.sh" # Make sure the script is in the same directory or provide the full path
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh", # Make the script executable
      "/tmp/script.sh ${var.elasticsearch_private_ip}" # Run the script with an argument
    ]
  }
}

