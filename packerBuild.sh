#!/bin/bash
set -xe
mkdir git_local || true
mkdir workdir || true
mkdir logs || true
sudo $(which packer) build --only arm-image.mirteopi build.pkr.hcl | tee logs/log-"$(date +"%Y-%m-%d %H:%M:%S")".txt

finalize() {
	imagefile=$1
	/usr/bin/time -v sudo ./add_partition_shell.sh workdir/$imagefile.img
	sudo ./pishrink.sh workdir/$imagefile.img || true
    newImageFile=build/"$imagefile"_"$(date +"%d-%m-%Y_%H_%M")".img
	sudo cp workdir/$imagefile.img "$newImageFile"
	xz -T0 --keep -v "$newImageFile"
	# xz -T8 --keep -v 
}

# finalize "mirteopi2"
finalize "mirteopi"