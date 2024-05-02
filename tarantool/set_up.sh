#!/bin/bash
docker stop tarantool-server #> /dev/null 2>&1 
rm -rf ./content
mkdir ./content

docker build -t tarantool .
docker run --rm -it -v ./content:/opt/tarantool/ --name tarantool-server -d tarantool

cp $(pwd)/router.lua $(pwd)/content/router.lua
cp $(pwd)/storage.lua $(pwd)/content/storage.lua
cp $(pwd)/config.yaml $(pwd)/content/config.yaml
cp $(pwd)/instances.yaml $(pwd)/content/instances.yaml
cp $(pwd)/bank-scm-1.rockspec $(pwd)/content/bank-scm-1.rockspec
cp $(pwd)/start_cluster.sh $(pwd)/content/start_cluster.sh
chmod +x ./content/start_cluster.sh

docker exec -it tarantool-server bash