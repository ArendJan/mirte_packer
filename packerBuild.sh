#!/bin/bash
set -xe
if [ "$EUID" -eq 0 ]
  then echo "Please don't run as root"
  exit
fi
mkdir git_local || true
mkdir workdir || true
mkdir logs || true
# --only arm-image.mirteopi 
sudo $(which packer) build build.pkr.hcl | tee logs/log-"$(date +"%Y-%m-%d %H:%M:%S")".txt

finalize() {
	imagefile=$1
	/usr/bin/time -v sudo ./add_partition_shell.sh workdir/$imagefile.img
	sudo ./pishrink.sh workdir/$imagefile.img || true
    newImageFile=build/"$imagefile"_"$(date +"%d-%m-%Y_%H_%M")".img
	sudo cp workdir/$imagefile.img "$newImageFile"
	xz -T0 --keep -v "$newImageFile"
}

finalize "mirteopi2"
finalize "mirteopi"