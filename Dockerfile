FROM ubuntu

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y qemu qemu-user-static binfmt-support xz-utils wget parted git && \
    mkdir -p /mnt/image && \
    apt install -y make build-essential && \
    cpan -fi YAML Hash::Merge::Simple && \
    ln -s /proc/self/mounts /etc/mtab
COPY mount_image.sh /root/
COPY umount_image.sh /root/
RUN     chmod +x /root/mount_image.sh
RUN     chmod +x /root/umount_image.sh
# ENTRYPOINT [ "/root/mount_image.sh" ]