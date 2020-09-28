#1
fdisk /dev/vdb
n
p
1
+300M
w

#2
blkid /dev/vdb1 | awk '{print $2}' > partUUID

#3
mkfs -t ext4 -b 4096 /dev/vdb1

#4
tune2fs -l /dev/vdb1

#5
tune2fs -i 2m /dev/vdb1
tune2fs -c 2 /dev/vdb1

#6
mkdir /mnt/newdisk
mount /dev/vdb1 /mnt/newdisk

#7
ln -s /mnt/newdisk mounted

#8
mkdir /mnt/newdisk/ololo

#9
echo "/dev/vdb1 /mnt/newdisk ext4 noexec,noatime 0 0" >> /etc/fstab
systemctl daemon-reload
reboot
touch /mnt/newdisk/ololo/test
chmod +x /mnt/newdisk/ololo/test
/mnt/newdisk/ololo/test

#10
umount /dev/vdb1
fdisk /dev/vdb
d
1
n
p
1
+350M
w

#11
fsck -n /dev/vdb1

#12

