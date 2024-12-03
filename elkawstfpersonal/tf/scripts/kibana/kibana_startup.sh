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
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.16.1-amd64.deb
shasum -a 512 kibana-8.16.1-amd64.deb 
sudo dpkg -i kibana-8.16.1-amd64.deb

# Update Kibana configuration
echo "server.host: '0.0.0.0'" >> /etc/kibana/kibana.yml
echo "elasticsearch.hosts: [\"http://${aws_instance.elasticsearch_instance.private_ip}:9200\"]" >> /etc/kibana/kibana.yml

# sudo bin/elasticsearch-create-enrollment-token -s kibana
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service
sudo systemctl start kibana.service
sudo systemctl status kibana.service | grep "Active*"