#!/bin/bash
set -e

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

# losetup -D # just remove all
# # Mount image
# loopvar=$(losetup -fP --show /mirte_sd.img)
apt install kpartx
kpartx /mirte_sd.img
# losetup -D # just remove all
# Mount image
# loopvar=$(losetup -fP --show /mirte_sd.img)
mount -t ext4 /dev/mapper/loop1p1 /mnt/image/ || (
	. /root/mount_image.sh
	exit 1
) # rerun mount, 2nd time it often works

# Mount other folders
cp /usr/bin/qemu-arm-static /mnt/image/usr/bin/
cp /usr/bin/qemu-aarch64-static /mnt/image/usr/bin/
mount --bind /dev /mnt/image/dev/
mount --bind /sys /mnt/image/sys/
mount --bind /proc /mnt/image/proc/
mount --bind /dev/pts /mnt/image/dev/pts
chroot /mnt/image /bin/bash -c 'su mirte -c "cd ; bash"' # chroot into image, log in as mirte and cd to home folder
# /root/umount_image.sh

echo "If you see this before you were able to edit your sd image, run /root/mount_image.sh, otherwise run exit to get back to your normal terminal"
bash -i
