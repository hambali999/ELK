#!/bin/bash

# Wait for User Data to be Completed
mkdir /usr/local/variables/
REGION=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo $REGION >> /usr/local/variables/variables.txt
echo $INSTANCE_ID >> /usr/local/variables/variables.txt

# Update and install dependencies
sudo apt update && sudo apt install -y wget tar unzip openjdk-21-jre-headless > /tmp/dependencies_install.log 2>&1
sudo apt-get upgrade -y
sudo apt-get install -y jq curl

echo "=== Starting Elasticsearch setup... ==="

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

# Add Elasticsearch to PATH
echo 'export PATH=$PATH:/usr/local/elasticsearch/bin' | sudo tee -a /home/elasticsearch_user/.bashrc

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
export PATH=$PATH:/usr/local/bin

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

# Fetch the custom elasticsearch.yml from S3 and set permissions
aws s3 cp s3://mysgelkbucket/elasticsearch.yml /usr/local/elasticsearch/config/elasticsearch.yml
if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch elasticsearch.yml from S3"
  exit 1
fi
sudo chown elasticsearch_user:elasticsearch_user /usr/local/elasticsearch/config/elasticsearch.yml
sudo chmod 660 /usr/local/elasticsearch/config/elasticsearch.yml
sleep 10

echo "Running configuration for Elasticsearch..."
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
echo $PRIVATE_UP >> /usr/local/variables/variables.txt
sudo sed -i "s/^cluster.initial_master_nodes:.*$/cluster.initial_master_nodes: [\"${PRIVATE_IP}\"]/" /usr/local/elasticsearch/config/elasticsearch.yml
# sudo systemctl restart elasticsearch

# Reload systemd and start Elasticsearch service
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

# Verify Elasticsearch is running
# if ! systemctl is-active --quiet elasticsearch; then
#   echo "Error: Elasticsearch service failed to start"
#   exit 1
# fi

# Confirm Elasticsearch is reachable
sleep 10
# curl -X GET "http://localhost:9200/" || {
#   echo "Error: Elasticsearch is not reachable"
#   exit 1
# }

echo "Instance setup completed" > /var/log/instance-setup.log

# Signal that setup is complete
aws ec2 signal-instance-availability --instance-id $INSTANCE_ID

