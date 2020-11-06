mdadm --zero-superblock --force /dev/vd{c,d}
wipefs --all --force /dev/vd{c,d}
mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/vd{c,d}
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
mkfs.ext4 /dev/md0
mkdir /mnt/raid
mount /dev/md0 /mnt/raid
echo "/dev/md0 /mnt/raid ext4 defaults 1 2" >> /etc/fstab

