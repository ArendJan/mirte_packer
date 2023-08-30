#!/bin/bash
set -xe
# /root/umount_image.sh
ls -al /
# Mount image and resize filesystem
loopvar=$(losetup -fP --show /mirte_sd.img)
mount -t ext4 $(ls $loopvar* | tail -n1) /mnt/image/

# Mount other folders
cp /usr/bin/qemu-arm-static /mnt/image/usr/bin/
cp /usr/bin/qemu-aarch64-static /mnt/image/usr/bin/
mount --bind /dev /mnt/image/dev/
mount --bind /sys /mnt/image/sys/
mount --bind /proc /mnt/image/proc/
mount --bind /dev/pts /mnt/image/dev/pts
chroot /mnt/image
/root/umount_image.sh
