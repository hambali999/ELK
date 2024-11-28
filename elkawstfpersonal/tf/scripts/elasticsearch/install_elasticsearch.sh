#!/bin/bash

# Update and install dependencies
sudo apt update
sudo apt install -y wget tar
# sudo apt install default-jre 
sudo apt install openjdk-21-jre-headless

# Download and verify Elasticsearch
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.16.1-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.16.1-linux-x86_64.tar.gz.sha512
shasum -a 512 -c elasticsearch-8.16.1-linux-x86_64.tar.gz.sha512

# Extract and set up Elasticsearch
tar -xzf elasticsearch-8.16.1-linux-x86_64.tar.gz
sudo mv elasticsearch-8.16.1 /usr/local/elasticsearch

# Create a non-root user for Elasticsearch
sudo useradd -m -s /bin/bash elasticsearch_user
sudo chown -R elasticsearch_user:elasticsearch_user /usr/local/elasticsearch

# Add environment variables (optional, if needed)
echo 'export PATH=$PATH:/usr/local/elasticsearch/bin' | sudo tee -a /home/elasticsearch_user/.bashrc

# Install unzip 
sudo apt-get -y install unzip

# Install AWS CLI to download from S3 (if not installed)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Fetch the custom elasticsearch.yml from S3 and replace the existing one
aws s3 cp s3://mysgelkbucket/elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml
aws s3 cp elasticsearch.yml s3://mysgelkbucket/elasticsearch.yml
aws s3 api wait bucket-exists --bucket mysgelkbucket

# Set permissions for the new elasticsearch.yml
sudo chown elasticsearch:elasticsearch /usr/local/elasticsearch/config/elasticsearch.yml
sudo chmod 644 /usr/local/elasticsearch/config/elasticsearch.yml

# Run Elasticsearch as non-root user
sudo -u elasticsearch_user /usr/local/elasticsearch/bin/elasticsearch &


# Create a systemd service for Elasticsearch
cat <<EOF | sudo tee /etc/systemd/system/elasticsearch.service
[Unit]
Description=Elasticsearch
Documentation=https://www.elastic.co
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=elasticsearch_user
Group=elasticsearch_user
ExecStart=/usr/local/elasticsearch/bin/elasticsearch
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Elasticsearch service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Check if Elasticsearch is running
ps aux | grep elasticsearch

# Check logs for any errors
# cat /usr/local/elasticsearch/logs/elasticsearch.log

# check systemctl elasticsearch.service is running
systemctl status elasticsearch.service
curl -X GET "http://localhost:9200/"




