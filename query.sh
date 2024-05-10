lineno=$1
if [[ $# -eq 0 ]] ; then
    echo "Usage: ./${0} <line-no>"
    echo 'Provide a line number to find the next nearest neighbors'
    exit 0
fi

line=`sed -n "${lineno}p" mydata/data.json | sed '$ s/.$//'`
vector=`echo "$line" |jq -c '.vector'`
title=`echo "$line" |jq -c '.title'`

response=`curl -s -H "Content-Type: application/json" "http://localhost:8983/solr/blacklight-core/select?fl=id,title,score" -d "{\"query\": \"{!knn f=vector topK=5}$vector\"}"|jq '.response.docs'`

echo "$response"
echo "These are the results most similar to: \"$title\""
