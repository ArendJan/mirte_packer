#!/bin/bash
set -xe
mkdir git_local || true
mkdir workdir || true
/usr/bin/time -v sudo $(which packer) build build.pkr.hcl | tee log.txt
sudo ./pishrink.sh workdir/mirteopi2.img || true
sudo cp workdir/mirteopi2.img build/mirte_opi2_"$(date +"%d-%m-%Y")".img
cd build && xz -T8 --keep -v mirte_opi2_"$(date +"%d-%m-%Y")".img
# xz -T8 --keep -v
