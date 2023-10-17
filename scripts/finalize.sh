#!/bin/bash

finalize() {
	imagefile=$1
	sudo ./add_partition_local/add_partition.sh $imagefile
	sudo ./pishrink.sh $imagefile || true
	filename=$(basename $imagefile .img)
	newImageFile="build/$filename"_"$(date +"%d-%m-%Y_%H_%M")".img
	sudo cp "$imagefile" "$newImageFile"
	xz -T0 --keep -v "$newImageFile" || true
}