#!/bin/bash
set -xe
if [ "$EUID" -eq 0 ]; then
	echo "Please don't run as root"
	exit
fi
only_flags=""
if (($# > 0)); then
	only_flags="--only arm-image.$1"
fi

mkdir git_local || true
mkdir workdir || true
mkdir logs || true
sudo packer build $only_flags build.pkr.hcl | tee logs/log-"$(date +"%Y-%m-%d %H:%M:%S")".txt

finalize() {
	imagefile=$1
	/usr/bin/time -v sudo ./add_partition_shell.sh workdir/$imagefile.img
	sudo ./pishrink.sh workdir/$imagefile.img || true
	newImageFile=build/"$imagefile"_"$(date +"%d-%m-%Y_%H_%M")".img
	sudo cp workdir/$imagefile.img "$newImageFile"
	xz -T0 --keep -v "$newImageFile"
}

if (($# > 1)); then
	finalize "$1"
else
	finalize "mirteopi2"
	finalize "mirteopi"
fi
