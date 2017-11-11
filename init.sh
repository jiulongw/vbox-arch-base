#!/bin/bash

# curl -L goo.gl/fPxQv7 | bash

# init disk
sgdisk -Z --new=0:0:0 --typecode=0:8300 --new=0:0:0 --typecode=0:EF02 /dev/sda
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda1 /mnt

# rank mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
curl -L "https://www.archlinux.org/mirrorlist/?country=US&protocol=http&protocol=https&use_mirror_status=on" | sed 's/^#Server/Server/' | head -20 > /etc/pacman.d/mirrorlist.raw
rankmirrors /etc/pacman.d/mirrorlist.raw > /etc/pacman.d/mirrorlist

pacstrap /mnt base openssh grub

genfstab -p /mnt >> /mnt/etc/fstab

curl -L "https://raw.githubusercontent.com/jiulongw/vbox-arch-base/master/install.sh" > /mnt/root/install.sh
arch-chroot /mnt "/bin/bash" "/root/install.sh"

umount /mnt

reboot
