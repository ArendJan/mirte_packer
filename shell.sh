#!/bin/bash
echo $1
sudo docker run --privileged -v /home/arendjan/packerTest/"$1":/mirte_sd.img -it "$(docker build -q .)"