# Index a document in Elasticsearch (using POST or PUT)
curl -X POST "http://13.215.183.201:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe",
  "message": "This is a test message"
}
'

curl -X GET "http://13.215.183.201:9200/my_index/_doc/1"

# Create index
curl -X PUT "http://13.215.183.201:9200/my_index"

# Insert a document to my index
curl -X POST "http://13.215.183.201:9200/my_index/_doc/1" -H 'Content-Type: application/json' -d'
{
  "user": "john_doe",
  "message": "This is a test message"
}
'
