#!/bin/bash
set -xe
/usr/bin/time -v sudo $(which packer) build . | tee log.txt
sudo ./pishrink.sh build/*.img || true

# xz -T8 --keep -v
