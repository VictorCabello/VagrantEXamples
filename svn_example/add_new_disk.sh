set -x
sudo yum install -y parted
echo -e "n\ne\n1\n\n\nw\n" | sudo fdisk /dev/sdb
sudo partprobe /dev/sdb
echo -e "n\nl\n\n\nw\n" | sudo fdisk /dev/sdb
sudo partprobe /dev/sdb

sudo mkfs.ext4 /dev/sdb5

sudo mkdir /app

echo "/dev/sdb5               /app                   ext4    defaults        0 0" | sudo tee -a /etc/fstab

sudo mount /app
