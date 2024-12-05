#!/bin/bash

# Arguments: $1 is the elasticsearch private IP passed from Terraform
elasticsearch_ip=$1

# Logstash installation and configuration
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk wget

# Install Metricbeat
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.16.1-amd64.deb
sudo dpkg -i metricbeat-8.16.1-amd64.deb
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install metricbeat

# Create Logstash configuration file (using sudo to avoid permission issues)
echo "input {
  file {
    path => \"/var/log/example.log\"
    start_position => \"beginning\"
  }
}

filter {
  grok {
    match => { \"message\" => \"%{DAY:day} %{MONTH:month} %{MONTHDAY:monthdat} %{TIME:time} %{WORD:timezone} %{YEAR:year} %{WORD:status} %{GREEDYDATA:word}\" }
  }
}

output {
  elasticsearch {
    hosts => [\"http://${elasticsearch_ip}:9200\"]
    index => \"example-logs-%{+YYYY.MM.dd}\"
  }
  stdout { codec => rubydebug }
}" | sudo tee /etc/logstash/conf.d/logstash.conf

# Start and enable Logstash
sudo systemctl enable metricbeat
sudo systemctl start metricbeat