#!/bin/bash
set -x

# Cleanup
rm /mnt/image/usr/bin/qemu-arm-static
rm /mnt/image/usr/bin/qemu-aarch64-static
rm -rf /mnt/image/working_dir

# Unmount
umount -l /mnt/image/dev/pts
umount -l /mnt/image/dev
umount -l /mnt/image/sys
umount -l /mnt/image/proc

# Remove loop device
loopdev=$(mount | grep image | awk '{print $1}' | rev | cut -c 3- | rev)
umount -l /mnt/image/
losetup -d $loopdev
true
