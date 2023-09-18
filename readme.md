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


add partition:
fdisk /mirte
n
p
2
2048
+1G
// nu partitie erbij 
t // type
2 
7 // ntfs
w


apt install ntfs-3g
kpartx -a /mirte_sd.img
mkfs.ntfs --partition-start=2048 /dev/mapper/loop33p2  2097152