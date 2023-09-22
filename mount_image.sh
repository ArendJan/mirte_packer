#!/bin/bash
set -ex

if true; then
dd if=/dev/zero bs=1M count=1024 >>/mirte_sd.img
echo ",+1G" | sfdisk -N 1 /mirte_sd.img || true
fi

loop=$(kpartx -av /mirte_sd.img)
echo $loop
loopvar=$(echo $loop | grep -oP 'loop[0-9]*' | head -1)
echo $loopvar

e2fsck -f /dev/mapper/${loopvar}p1

resize2fs /dev/mapper/${loopvar}p1

mount -t ext4 /dev/mapper/${loopvar}p1 /mnt/image/ || (
	exit 1
) # rerun mount, 2nd time it often works

cp /usr/bin/qemu-arm-static /mnt/image/usr/bin/
cp /usr/bin/qemu-aarch64-static /mnt/image/usr/bin/
mount --bind /dev /mnt/image/dev/
mount --bind /sys /mnt/image/sys/
mount --bind /proc /mnt/image/proc/
mount --bind /dev/pts /mnt/image/dev/pts
users=$(cut -d: -f1 /etc/passwd)
echo $users
if echo $users | grep -q "mirte"; then

chroot /mnt/image /bin/bash -c 'su mirte -c "cd ; bash"' || echo "Something went wrong" || true # chroot into image, log in as mirte and cd to home folder
 else 
 chroot /mnt/image /bin/bash -c 'su root -c "cd ; bash"' || echo "Something went wrong" || true # chroot into image, log in as mirte and cd to home folder
fi
echo "If you see this before you were able to edit your sd image, run /root/mount_image.sh, otherwise run exit to get back to your normal terminal"
# bash -i
rm /mnt/image/usr/bin/qemu-arm-static
rm /mnt/image/usr/bin/qemu-aarch64-static
rm -rf /mnt/image/working_dir

# Unmount
umount -l /mnt/image/dev/pts
umount -l /mnt/image/dev
umount -l /mnt/image/sys
umount -l /mnt/image/proc

umount /mnt/image/

kpartx -dv /dev/${loopvar}

bash -i