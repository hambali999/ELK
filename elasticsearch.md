# Index a document in Elasticsearch (using POST or PUT)
curl -X POST "http://13.215.183.201:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe",
  "message": "This is a test message"
}
'

curl -X GET "http://18.136.101.182:9200/my_index/_doc/1"

# Get 
curl -X GET "http://18.136.101.182:9200/"

# Create index
curl -X PUT "http://18.136.101.182:9200/my_index"

# Insert a document to my index
curl -X POST "http://18.136.101.182:9200/my_index/_doc/2" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe_2",
  "message": "This is a test message miao 2"
}'

# Retrive the index
curl -X GET "http://18.136.101.182:9200/my_index/_doc/1"

# Retrieve all documents inside the index
curl -X GET "http://18.136.101.182:9200/my_index/_search?pretty=true"

# Retrive only the document using 'jq' 
curl -X GET "http://18.136.101.182:9200/my_index/_search?pretty=true" | jq '.hits.hits'




