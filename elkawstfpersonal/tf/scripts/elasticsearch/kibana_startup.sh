    #!/bin/bash
    
    # Update packages
    apt-get update && apt-get install -y wget gnupg

    # Install Kibana
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
    echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-8.x.list
    apt-get update && apt-get install -y kibana

    # Update Kibana configuration
    echo "server.host: 0.0.0.0" >> /etc/kibana/kibana.yml
    echo "elasticsearch.hosts: [\"http://${aws_instance.elasticsearch_instance.private_ip}:9200\"]" >> /etc/kibana/kibana.yml

    # Enable and start Kibana
    systemctl enable kibana
    systemctl start kibana