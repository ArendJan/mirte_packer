#!/bin/bash
set -xe
PACKER_CONFIG_DIR=$HOME /usr/bin/time -v sudo -E $(which packer) build . | tee log.txt
sudo ./pishrink.sh build/*.img || true

# xz -T8 --keep -v
