#!/bin/bash
set -xe
mkdir git_local || true
mkdir build || true
/usr/bin/time -v sudo $(which packer) build . | tee log.txt
sudo ./pishrink.sh build/mirteopi2.img || true
xz -T8 --keep -v build/mirteopi2.img
mkdir imgs || true
mv build/mirteopi2.img.xz imgs/$(date +'%Y-%m-%d').img.xz