#!/bin/bash
set -ex
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

if  sfdisk -l /mirte_sd.img | grep -q '.img2'; then
	echo "Already contains extra partition"
	exit 1
fi

startLocation=$(sfdisk -l -o start -N1 /mirte_sd.img | tail -1)
# should be 40960 for zero2, 8192 for zero1

extraSize="1G"

dd if=/dev/zero bs=1M count=1024 >>/mirte_sd.img
echo "+$extraSize" | sfdisk --move-data -N 1 /mirte_sd.img
echo "$startLocation, $extraSize, b" | sfdisk -a /mirte_sd.img
loop=$(kpartx -av /mirte_sd.img)
echo $loop
loopvar=$(echo $loop | grep -oP 'loop[0-9]*' | head -1)
echo $loopvar
mkfs.fat /dev/mapper/${loopvar}p2 -n "MIRTE" -i "9EE2A262" # some random id from a previous build
mount_dir=`mktemp -d `
echo $mount_dir
mount /dev/mapper/${loopvar}p2 $mount_dir
cp /root/default_partition_files/. $mount_dir


kpartx -dv /dev/${loopvar}
echo "done"
