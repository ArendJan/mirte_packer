FROM ubuntu

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y qemu qemu-user-static binfmt-support xz-utils wget parted git fdisk kpartx ntfs-3g dosfstools fdisk kpartx ntfs-3g dosfstools && \
   ( mkdir -p /mnt/image || true) && \
   ( ln -s /proc/self/mounts /etc/mtab || true)
COPY add_partition.sh /root/
# COPY umount_image.sh /root/
RUN     chmod +x /root/add_partition.sh
# RUN     chmod +x /root/umount_image.sh # not used for now
ENTRYPOINT [ "/root/add_partition.sh" ]