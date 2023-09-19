FROM ubuntu

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y qemu qemu-user-static binfmt-support xz-utils wget parted git && \
    mkdir -p /mnt/image && \
    apt install -y make build-essential && \
    ln -s /proc/self/mounts /etc/mtab
COPY add_partition.sh /root/
# COPY umount_image.sh /root/
RUN     chmod +x /root/add_partition.sh
RUN apt install fdisk kpartx ntfs-3g -y
# RUN     chmod +x /root/umount_image.sh # not used for now
ENTRYPOINT [ "/root/add_partition.sh" ]