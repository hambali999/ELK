# Index a document in Elasticsearch (using POST or PUT)
curl -X POST "http://3.1.8.182:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe",
  "message": "This is a test message"
}
'

curl -X GET "http://3.1.8.182:9200/my_index/_doc/1"
curl -X GET "http://3.1.8.182:9200/my-index/_doc"


# Get 
curl -X GET "http://3.1.8.182:9200/"

# Create index
curl -X PUT "http://3.1.8.182:9200/my_index"

# Insert a document to my index
curl -X POST "http://3.1.8.182:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe_2",
  "message": "This is a test message miao 1"
}'

# Retrive the index
curl -X GET "http://3.1.8.182:9200/my_index/_doc/1"

# Retrieve all documents inside the index
curl -X GET "http://3.1.8.182:9200/my_index/_search?pretty=true"

# Retrive only the document using 'jq' 
curl -X GET "http://3.1.8.182:9200/my_index/_search?pretty=true" | jq '.hits.hits'



=====================================
# Send logs to elasticsearch from logstash
echo $(date) "ERROR This is an error log 1" | sudo tee -a /var/log/example.log
echo $(date) "ERROR This is an error log 2" | sudo tee -a /var/log/example.log
echo $(date) "SUCCESS This is a success log 1" | sudo tee -a /var/log/example.log
echo $(date) "SUCCESS This is a success log 2" | sudo tee -a /var/log/example.log
echo $(date) "SUCCESS This is a success log 3" | sudo tee -a /var/log/example.log



# Verify logs in elasticsearch 
curl -X GET "http://18.140.1.255:9200/_cat/indices?v"

# Verify logs in kiban
go inside kibana :5601
In Kibana, go to Management > Kibana Index Patterns.
Click Create index pattern.
Enter the index pattern example-logs-* (or the actual pattern matching your indices).
Select the time field (usually @timestamp or your custom field).
Click Create.

# GROK DEBUGGER
https://grokdebugger.com/