# Build Mirte image using Packer

## Install
run sudo ./packerInstall.sh to download stuff

## Build
Run sudo ./packerBuild.sh to build the image. Will take some time
Put your local files in git_local/ and they will be copied
edit settings.sh to select features and extra scripts

## Shell to edit
run ./shell.sh \<img file> (Docker required) and it should present you with a shell in the image at the mirte home directory. Might take some time to build the docker image the first time


# TODOS:
- npm prebuilt
- store log on image
- rename image to date
- fix breaking qemu


Moving partition:
dd if=/dev/zero bs=1M count=1024 >> /mirte_sd.img
echo "+1G" | sfdisk --move-data -N 1 /mirte_sd.img

huidige:
/mirte_sd.img1      40960 16777215 16736256   8G 83 Linux

start altijd bij 40960
add partition:
fdisk /mirte
n
p
2
40960 !!!!!!
+1G
// nu partitie erbij 
t // type
2 
b // fat32
w
apt-get install dosfstools

kpartx -a /mirte_sd.img
mkfs.fat  /dev/mapper/loop33p2 