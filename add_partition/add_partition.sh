#!/bin/bash
set -e
stat /mirte_sd.img
ls -lah /
# only restart 4 times, otherwise it will be an infinite loop
if [[ ! -v RESTART_COUNT ]]; then
	RESTART_COUNT=0
else

	RESTART_COUNT=$((RESTART_COUNT + 1))
	if [[ $RESTART_COUNT == 4 ]]; then
		echo "Unable to mount the sd card after 4 tries"
		exit 1
	fi
fi
apt install kpartx
# kpartx /mirte_sd.img
# losetup -D # just remove all
# Mount image
# loopvar=$(losetup -fP --show /mirte_sd.img)
# echo $loopvar
# mount -t ext4 $(ls $loopvar* | tail -n1) /mnt/image/ || (
# 	. /root/add_partition.sh
# 	exit 1
# ) # rerun mount, 2nd time it often works
bash -i
echo "done"


fdisk
m
