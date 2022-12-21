#!/bin/bash

servicename=$1
array=("redis-oms-basket" "redis-oms-core" "redis-oms-inventory" "redis-oms-payment" "redis-siv")
array1=("redis-catalog-exporter")
array2=("redis-spa-proxy" "redis-spa-proxy-dev03")
if [[ ${array[@]} =~  ${servicename} ]]; then
    cd /home/qbdevops/redis
    docker-compose restart ${servicename}

elif [[ ${array1[@]} =~  ${servicename} ]]; then
    cd /home/qbdevops/catlog_exporter
    docker-compose restart ${servicename}

elif [[ ${array2[@]} =~  ${servicename} ]]; then
    cd /home/qbdevops/spa-proxy-redis
    docker-compose restart ${servicename}

else 
    echo "enter a valid service name"

fi

echo "$servicename restarted"


#!/bin/sh
REPO_NAME=$(aws ecr describe-repositories --query "repositories[].repositoryName" --output text --region ap-northeast-1);

for repo in $REPO_NAME; do
    if [$repo != 2.0/*] && [$repo != 1.5/*]
        echo "$repo"
    fi
done
