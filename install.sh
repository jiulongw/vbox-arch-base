#!/bin/bash

HOST_NAME=vagrant
ROOT_PASSWD=vagrant
USER_NAME=vagrant
USER_PASSWD=vagrant
USER_PUBKEY_URL=https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub

echo $HOST_NAME > /etc/hostname

echo "Setting root password"
passwd <<EOF
$ROOT_PASSWD
$ROOT_PASSWD
EOF

useradd -m -G wheel -s /bin/bash $USER_NAME
passwd $USER_NAME <<EOF
$USER_PASSWD
$USER_PASSWD
EOF

# time zone
ln -fs /usr/share/zoneinfo/US/Pacific /etc/localtime

# locale
sed --in-place=.bak 's/^#en_US\.UTF-8/en_US\.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# bootloader
grub-install --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# sudo
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# key
mkdir -p /home/$USER_NAME/.ssh
curl -L "$USER_PUBKEY_URL" > /home/$USER_NAME/.ssh/authorized_keys
chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh/authorized_keys

pacman -S --noconfirm --needed linux-headers virtualbox-guest-dkms virtualbox-guest-utils

systemctl enable dhcpcd
systemctl enable sshd
systemctl enable vboxservice

mkdir -p /media && chown root:wheel /media
usermod -a -G vboxsf $USER_NAME

pacman -Scc <<EOF
y
y
EOF

dd if=/dev/zero of=/ZERO bs=4M

rm /ZERO
rm /root/install.sh
cat /dev/null > /root/.bash_history && history -c
