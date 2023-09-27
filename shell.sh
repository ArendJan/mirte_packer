#!/bin/bash
set -xe
echo $1
IMG_FILE=$(readlink -f ./build/"$1") 
sudo docker build .
sudo docker run --privileged -v "$IMG_FILE":/mirte_sd.img -it "$(sudo docker build -q .)"