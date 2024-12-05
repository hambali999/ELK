#!/bin/bash

# Arguments: $1 is the Elasticsearch private IP passed from Terraform
elasticsearch_ip=$1

# Update package lists
sudo apt-get update

# Install Metricbeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install metricbeat -y

# backup current configuration
sudo cp /etc/metricbeat/metricbeat.yml /etc/metricbeat/metricbeat.yml.bak

# Configure Metricbeat to send metrics to Elasticsearch
# The line is now uncommented, enabling the output.elasticsearch configuration.
sudo sed -i "s|#output.elasticsearch:.*|output.elasticsearch:|" /etc/metricbeat/metricbeat.yml
# Now we insert our elasticsearch ip in the metricbeat configuration file
sudo sed -i "/output.elasticsearch:/,/^[^ ]/ s|#\? *hosts:.*|  hosts: [\"${elasticsearch_ip}:9200\"]|" /etc/metricbeat/metricbeat.yml

# Enable and configure the Metricbeat system module
sudo metricbeat modules enable system
sudo metricbeat setup -e

# Start and enable Metricbeat
sudo systemctl enable metricbeat
sudo systemctl start metricbeat
