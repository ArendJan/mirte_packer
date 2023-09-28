#!/bin/bash
set -ex

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
