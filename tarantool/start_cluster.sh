#!/bin/bash
DATA_PATH=/opt/tarantool/
DIR_PATH=~/instances.enabled/bank
cd ~
tt init
mkdir -p $DIR_PATH
echo "Creating configs"
mv $DATA_PATH/router.lua $DIR_PATH
mv $DATA_PATH/storage.lua $DIR_PATH
mv $DATA_PATH/config.yaml $DIR_PATH
mv $DATA_PATH/instances.yaml $DIR_PATH
mv $DATA_PATH/bank-scm-1.rockspec $DIR_PATH

echo "Starting cluster"
tt rocks install expirationd
# tt check $DIR_PATH
tt build bank
sleep 1
tt start bank 
sleep 1
tt connect bank:router-a-001