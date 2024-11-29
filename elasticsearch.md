# Index a document in Elasticsearch (using POST or PUT)
curl -X POST "http://13.250.37.252:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe",
  "message": "This is a test message"
}
'

curl -X GET "http://13.250.37.252:9200/my_index/_doc/1"

# Get 
curl -X GET "http://13.250.37.252:9200/"

# Create index
curl -X PUT "http://13.250.37.252:9200/my_index"

# Insert a document to my index
curl -X POST "http://13.250.37.252:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe_2",
  "message": "This is a test message miao 1"
}'

# Retrive the index
curl -X GET "http://13.250.37.252:9200/my_index/_doc/1"

# Retrieve all documents inside the index
curl -X GET "http://13.250.37.252:9200/my_index/_search?pretty=true"

# Retrive only the document using 'jq' 
curl -X GET "http://13.250.37.252:9200/my_index/_search?pretty=true" | jq '.hits.hits'




