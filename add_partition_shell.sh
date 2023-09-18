#!/bin/bash
echo $1
IMG_FILE=$(readlink -f ./build/"$1") 

cd add_partition

sudo docker run --privileged -v "$IMG_FILE":/mirte_sd.img -it "$(docker build -q -f partition.Dockerfile .)"