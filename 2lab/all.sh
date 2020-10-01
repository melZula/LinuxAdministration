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
# создаем раздел
fdisk /dev/vdb
n
p
2
+12M
w
# создаем журнал с размером блока как на vdb1
mke2fs -O journal_dev -b 4096 /dev/vdb2
# отключаем журнал на /dev/vdb1
tune2fs -O "^has_journal" /dev/vdb1
# подключаем журнал vdb1 на vdb2
tune2fs -J device=/dev/vdb2 /dev/vdb1

#13
fdisk /dev/vdb
n
p
3
+100M
n
p
+100M

#14
vgcreate vg1 /dev/vdb3 /dev/vdb4
lvcreate -L 190M vg1
# lvdisplay, lvs
mkfs.ext4 /dev/vg1/lvol0
mkdir /mnt/supernewdisk
mount /dev/vg1/lvol0 /mnt/supernewdisk

#15
mkdir /mnt/share
mount.cifs //192.168.122.1/shared /mnt/share -o guest

#16
echo "//192.168.122.1/shared /mnt/share cifs ro,uid=500,username=zula,password=123 0 0" >> /etc/fstab
systemctl daemon-reload
reboot
