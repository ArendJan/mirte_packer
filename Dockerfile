FROM ubuntu:devel

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y  software-properties-common && \
    add-apt-repository ppa:canonical-server/server-backports &&\
    apt install -y kpartx fdisk xfsprogs make build-essential qemu-user-static gpart qemu-system binfmt-support xz-utils wget parted git && \
    mkdir -p /mnt/image && \ 
   (ln -s /proc/self/mounts /etc/mtab || true)
COPY mount_image.sh /root/
COPY umount_image.sh /root/
RUN     chmod +x /root/mount_image.sh
RUN     chmod +x /root/umount_image.sh # not used for now
ENTRYPOINT [ "/root/mount_image.sh" ]