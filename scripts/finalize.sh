#!/bin/bash
. ./settings.sh 
finalize() {
	imagefile=$1
	if $INSTALL_PROVISIONING; then
		sudo ./add_partition_local/add_partition.sh $imagefile
	fi
	sudo ./pishrink.sh $imagefile || true
	filename=$(basename $imagefile .img)
	newImageFile="build/$filename"_"$(date +"%Y-%m-%d %H:%M:%S")".img
	sudo cp "$imagefile" "$newImageFile"
	xz -T0 --keep -v "$newImageFile" || true
}