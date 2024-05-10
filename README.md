# Blacklight Demo for dense vector search

Based on https://sease.io/2023/01/apache-solr-neural-search-tutorial.html

## Setup

1. `docker compose up solr`
2. Create a Type for dense vectors

```
curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field-type":{
     "name":"knn_vector384",
     "class":"solr.DenseVectorField",
     "vectorDimension": "384",
     "similarityFunction": "dot_product"
  }
}' http://localhost:8983/api/cores/blacklight-core/schema
```

3. Create a dynamic field

```
curl -X POST -H 'Content-type:application/json' --data-binary '{
  "add-field":{
     "name":"vector",
     "type":"knn_vector384",
     "indexed":true,
     "stored":true
  }
}' http://localhost:8983/api/cores/blacklight-core/schema
```

4. Add data

```
docker compose run --rm solr solr post -url "http://solr:8983/solr/blacklight-core/update" /mydata/data.json
```

5. Query Data

There is a shell script that will allow us to find similar data by specifying a row from `mydata/data.json`

```
./query.sh 51
```
