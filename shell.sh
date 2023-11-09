#!/bin/bash
image_url=$(realpath $1)
image_name=$(basename $image_url .img)
mkdir shell_workdir || true
packer build -var 'image_url='"$image_url"'' -var 'image_name='"$image_name"'' shell.pkr.hcl & 
if startCount=$( ls -l /tmp/armimg-* | grep -c ^d); then
    echo "ok"
else
    startCount=0
fi

until [ $( ( ls -l /tmp/armimg-* || true ) | grep -c ^d) -gt $startCount ]; do
    sleep 5
done 
tset # packer messes up the shell, so reset the shell settings, no clear
ARMDIR=$(ls -td /tmp/armimg-*/ | head -1) # get latest
echo "run sudo chroot $ARMDIR in another shell to also log into the image. Stop by running rm /stopshell"

sudo chroot $ARMDIR
wait
