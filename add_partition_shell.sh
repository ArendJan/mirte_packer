#!/bin/bash
set -x
echo $1
IMG_FILE=$(readlink -f ./"$1") 
sudo modprobe loop
cd add_partition
docker build -f partition.Dockerfile .
sudo docker run --privileged -v "$IMG_FILE":/mirte_sd.img -it "$(docker build -q -f partition.Dockerfile .)"