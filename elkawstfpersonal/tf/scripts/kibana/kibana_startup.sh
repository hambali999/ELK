#!/bin/bash

mkdir /usr/local/variables/
mkdir /usr/local/kibana/
imds_token=$( curl -Ss -H "X-aws-ec2-metadata-token-ttl-seconds: 120" -XPUT 169.254.169.254/latest/api/token )
INSTANCE_ID=$( curl -Ss -H "X-aws-ec2-metadata-token: $imds_token" 169.254.169.254/latest/meta-data/instance-id )
PRIVATE_IP=$( curl -Ss -H "X-aws-ec2-metadata-token: $imds_token" 169.254.169.254/latest/meta-data/local-ipv4 )
echo $PRIVATE_IP >> /usr/local/variables/variables.txt
echo $INSTANCE_ID >> /usr/local/variables/variables.txt

# Update packages
sudo apt-get update && sudo apt-get install -y wget gnupg

# Install Kibana
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch
sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && sudo apt-get install -y kibana    


# Update Kibana configuration
echo "server.host: '0.0.0.0'" >> /etc/kibana/kibana.yml
echo "elasticsearch.hosts: [\"http://${aws_instance.elasticsearch_instance.private_ip}:9200\"]" >> /etc/kibana/kibana.yml

sudo bin/elasticsearch-create-enrollment-token -s kibana
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service