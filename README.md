# ELK
ELK - Elasticsearch, Logstash & Kibana
Podman - Containerization

## Commands
### Set Up a Pod for ELK
1. Create a Pod to group the Elasticsearch, Logstash, and Kibana containers.
#### command: 
podman pod create --name elk-pod -p 9200:9200 -p 5601:5601 -p 5044:5044

This pod maps:

Elasticsearch on port 9200
Kibana on port 5601
Logstash on port 5044

### Set up Elasticsearch
2. Run Elasticsearch in a container within the pod, assigning necessary environment variables for memory allocation and cluster name.
#### command: 
podman run -d --pod elk-pod --name elasticsearch \
  -e "discovery.type=single-node" \
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
  -v elasticsearch-data:/usr/share/elasticsearch/data \
  docker.io/library/elasticsearch:8.0.0

Notes:
The discovery.type=single-node environment variable allows Elasticsearch to run in standalone mode.
ES_JAVA_OPTS sets Java heap size.

### Set up Logstash
3. Create a configuration file for Logstash (logstash.conf) to specify input, filter, and output settings. A simple example: logstash.conf
#### command:
podman run -d --pod elk-pod --name logstash \
  -v $(pwd)/logstash.conf:/usr/share/logstash/pipeline/logstash.conf \
  docker.io/library/logstash:8.0.0


### Set up Kibana
4. Run the Kibana container and connect it to Elasticsearch:
#### command:
podman run -d --pod elk-pod --name kibana \
  -e "ELASTICSEARCH_HOSTS=http://localhost:9200" \
  docker.io/library/kibana:8.0.0


apt-get update
apt-get install nano

test