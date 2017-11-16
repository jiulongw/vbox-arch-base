# Install Arch Linux in VirtualBox
Once boot from ISO and see the root shell, simply type this
```sh
curl -L goo.gl/fPxQv7 | bash
```

# Under the hood
It creates a single partition with `ext4` file system for `/dev/sda` (with
`EF02` partition reserved for grub), then installs `virtualbox-guest-utils`
in addition to the `base` package group.

This was originally desgined to create a base box for vagrant.  So it
configures `vagrant` user with necessary `ssh` configuration that enables
vagrant to manage the box.  Later I find out I don't really need these
vagrant features but kept the configuration in case I need them later.

# Extras
I set up this virtual machine so that I have a base Linux box to play CTF.
If you're interested, run following command after reboot and logged in
as `vagrant` user.
```
curl -L goo.gl/pJHMCG | bash
```

This will setup an XFCE4 desktop environment with useful tools for CTF.
