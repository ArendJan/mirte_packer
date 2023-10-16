#!/bin/bash

finalize() {
	imagefile=$1
	sudo ./add_partition_local/add_partition.sh workdir/$imagefile.img
	sudo ./pishrink.sh workdir/$imagefile.img || true
	newImageFile=build/"$imagefile"_"$(date +"%d-%m-%Y_%H_%M")".img
	sudo cp workdir/$imagefile.img "$newImageFile"
	xz -T0 --keep -v "$newImageFile" || true
}