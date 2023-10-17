#!/bin/bash
image_url=$(realpath $1)
image_name=$(basename $image_url .img)
mkdir shell_workdir
packer build -var 'image_url='"$image_url"'' -var 'image_name='"$image_name"'' shell.pkr.hcl & 

until [ -e /tmp/armimg-* ]; do
    sleep 1
done 
tset # packer messes up the shell, so reset the shell settings, no clear

echo "run sudo chroot /tmp/armimg-XXXXX in another shell to also log into the image. Stop by running rm /stopshell"
sudo chroot /tmp/armimg-*
wait
