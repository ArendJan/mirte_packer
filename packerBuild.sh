#!/bin/bash
set -xe
mkdir git_local || true
/usr/bin/time -v sudo $(which packer) build . | tee log.txt
sudo ./pishrink.sh build/mirteopi2.img || true

# xz -T8 --keep -v
