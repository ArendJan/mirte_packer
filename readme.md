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