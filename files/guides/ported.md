![Unstable](https://img.shields.io/static/v1?label=Status&message=Unstable&color=red&style=flat)
![WithOutArchTools](https://img.shields.io/static/v1?label=Without&message=ArchTools&color=blue&style=flat)
# Installation guide

From ArchWiki

This document is a guide for installing Arch Linux using the live system booted from an installation medium made from an official installation image. The installation medium provides accessibility features which are described on the page Install Arch Linux with accessibility options. For alternative means of installation, see Category:Installation process.

Before installing, it would be advised to view the FAQ. For conventions used in this document, see Help:Reading. In particular, code examples may contain placeholders (formatted in `italics`) that must be replaced manually.

For more detailed instructions, see the respective ArchWiki articles or the various programs' man pages, both linked from this guide. For interactive help, the IRC channel and the forums are also available.

## Contents
- [Pre-installation](#pre-installation)
  - [Acquire an installation image](#acquire-an-installation-image)
  - [Verify signature](#verify-signature)
  - [Prepare an installation medium](#prepare-an-installation-medium)
  - [Boot the live environment](#boot-the-live-environment)
  - [Set the console keyboard layout](#set-the-console-keyboard-layout)
  - [Verify the boot mode](#verify-the-boot-mode)
  - [Connect to the internet](#connect-to-the-internet)
  - [Update the system clock](#update-the-system-clock)
  - [Partition the disks](#partition-the-disks)
  - [Format the partitions](#format-the-partitions)
  - [Mount the file systems](#mount-the-file-systems)
- [Installation](#installation)
  - [Select the mirrors](#select-the-mirrors)
  - [Install essential packages](#install-essential-packages)
- [Configure the system](#configure-the-system)
  - [Fstab](#fstab)
  - [Chroot](#chroot)
  - [Time zone](#time-zone)
  - [Localization](#localization)
  - [Network configuration](#network-configuration)
  - [Initramfs](#initramfs)
  - [Root password](#root-password)
  - [Boot loader](#boot-loader)
- [Reboot](#reboot)
- [Post-installation](#post-installation)
- [See also](#see-also)

## Pre-installation

### Acquire an installation image

Visit the Download page and, depending on how you want to boot, acquire the ISO file or a netboot image, and the respective GnuPG signature.

### Verify signature

It is recommended to verify the image signature before use, especially when downloading from an HTTP mirror, where downloads are generally prone to be intercepted to serve malicious images.

On a system with GnuPG installed, do this by downloading the PGP signature (under Checksums in the Download page) to the ISO directory, and verifying it with:

```

$ gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig

```

Alternatively, from an existing Arch Linux installation run:

```

$ pacman-key -v archlinux-version-x86_64.iso.sig

```

Note: The signature itself could be manipulated if it is downloaded from a mirror site, instead of from archlinux.org as above. In this case, ensure that the public key, which is used to decode the signature, is signed by another, trustworthy key. The gpg command will output the fingerprint of the public key.

### Prepare an installation medium

The installation image can be supplied to the target machine via a USB flash drive, an optical disc or a network with PXE: follow the appropriate article to prepare yourself an installation medium from the chosen image.

### Boot the live environment

Note: Arch Linux installation images do not support Secure Boot. You will need to disable Secure Boot to boot the installation medium. If desired, Secure Boot can be set up after completing the installation.

1. Point the current boot device to the one which has the Arch Linux installation medium. Typically it is achieved by pressing a key during the POST phase, as indicated on the splash screen. Refer to your motherboard's manual for details.
2. When the installation medium's boot loader menu appears, select Arch Linux install medium and press Enter to enter the installation environment.
3. You will be logged in on the first virtual console as the root user, and presented with a Zsh shell prompt.

To switch to a different console—for example, to view this guide with Lynx alongside the installation—use the Alt+arrow shortcut. To edit configuration files, mcedit(1), nano and vim are available. See packages.x86_64 for a list of the packages included in the installation medium.

### Set the console keyboard layout

The default console keymap is US. Available layouts can be listed with:

```

ls /usr/share/kbd/keymaps/**/*.map.gz

```

To set the keyboard layout, pass a corresponding file name to loadkeys(1), omitting path and file extension. For example, to set a German keyboard layout:

```

loadkeys de-latin1

```

Console fonts are located in /usr/share/kbd/consolefonts/ and can likewise be set with setfont(8).

### Verify the boot mode

To verify the boot mode, list the efivars directory:

```

ls /sys/firmware/efi/efivars

```

If the command shows the directory without error, then the system is booted in UEFI mode. If the directory does not exist, the system may be booted in BIOS (or CSM) mode. If the system did not boot in the mode you wish to use, refer to your motherboard's manual.

### Connect to the internet

To set up a network connection in the live environment, go through the following steps:

- Ensure your network interface is listed and enabled, for example with ip-link(8):
```

ip link

```
- For Ethernet, connect your network interface. The wired network interface will be named following the eno*...*, ens*...*, enp*...* or enx*...* naming scheme. Use dhcpcd to get an IP address for it:
```

dhcpcd interface

```
  If you have a static IP address, see Network configuration#Static IP address.
- For Wi-Fi, ensure that the wireless card is not blocked with rfkill. Authenticate to the wireless network using iwctl. Then use dhcpcd as above to get an IP address:
```

iwctl station device connect SSID

dhcpcd interface

```
- Configure your network connection if you use any of the following: ISCSI, wireless WPA-EAP, wireless EDSA, wireless WPA-Enterprise, PPPoE, PPTP, or VPN. See the corresponding networking articles.

The connection may be verified with ping:

```

ping archlinux.org

```

### Update the system clock

Use timedatectl(1) to ensure the system clock is accurate:

```

timedatectl set-ntp true

```

To check the service status, use `timedatectl status`.

### Partition the disks

When recognized by the live system, disks are assigned to a block device such as /dev/sda, /dev/nvme0n1 or /dev/mmcblk0. To identify these devices, use lsblk or fdisk.

```

fdisk -l

```

Results ending in rom, loop or airoot may be ignored.

The following partitions are required for a chosen device:

- One partition for the root directory /.
- For booting in UEFI mode: an EFI system partition.

If you want to create any stacked block devices for LVM, system encryption or RAID, do it now.

Use fdisk or parted to modify partition tables. For example:

```

fdisk /dev/the_disk_to_be_partitioned

```

Note:
- If the disk does not show up, make sure the disk controller is not in RAID mode.
- If the disk from which you want to boot already has an EFI system partition, do not create another one, but use the existing partition instead.

#### Example layouts

| Mount point | Partition | Partition type | Suggested size |
|-------------|-----------|----------------|----------------|
| /mnt/boot   | /dev/efi_system_partition | EFI system partition | At least 300 MiB |
| [SWAP]      | /dev/swap_partition | Linux swap | More than 512 MiB |
| /mnt        | /dev/root_partition | Linux x86-64 root (/) | Remainder of the device |

### Format the partitions

Once the partitions have been created, each must be formatted with an appropriate file system. For example, to create an Ext4 file system on /dev/root_partition, run:

```

mkfs.ext4 /dev/root_partition

```

If you created a partition for swap, initialize it with mkswap(8):

```

mkswap /dev/swap_partition

```

For the EFI system partition, format it to FAT32 using mkfs.fat(8).

Note: For FAT32 the partition size should be at least 300 MiB. If you get the error `mkfs.fat: Attempt to create a filesystem larger than 4294967295 clusters`, use the `-s2 -S512` options or else use mkfs.fat -F32.

### Mount the file systems

Mount the root volume to /mnt. For example, if the root volume is /dev/root_partition:

```

mount /dev/root_partition /mnt

```

Create any remaining mount points (such as /mnt/boot) and mount their corresponding volumes.

If you created a swap volume, enable it with swapon(8):

```

swapon /dev/swap_partition

```

The genfstab(8) utility will later detect mounted file systems and swap space.

## Installation

### Select the mirrors

Packages to be installed must be downloaded from mirror servers, which are defined in /etc/pacman.d/mirrorlist. On the live system, after connecting to the internet, reflector updates the mirror list by choosing 20 most recently synchronized HTTPS mirrors and sorting them by download rate.

The higher a mirror is placed in the list, the more priority it is given when downloading a package. You may want to inspect the file to see if it is satisfactory. If it is not, edit the file accordingly, and move the geographically closest mirrors to the top of the list, although other criteria should be taken into account.

This file will later be copied to the new system by pacstrap, so it is worth getting right.

### Install essential packages

Use the pacstrap(8) script to install the base package, Linux kernel and firmware for common hardware:

```

pacstrap -K /mnt base linux linux-firmware

```

Tip:
- You can substitute linux for a kernel package of your choice, or you could omit it entirely when installing in a container.
- You could omit the installation of the firmware package when installing in a virtual machine or container.

The base package does not include all tools from the live installation, so installing other packages may be necessary for a fully functional base system. In particular, consider installing:
- userspace utilities for the file systems of the root file system,
- utilities for accessing RAID or LVM partitions,
- specific firmware for other devices not included in linux-firmware,
- software necessary for networking,
- a text editor,
- packages for accessing documentation in man and info pages: man-db, man-pages and texinfo.

To install other packages or package groups, append the names to the pacstrap command above (space separated) or use pacman while chrooted into the new system. For comparison, packages available in the live system can be found in packages.x86_64.

## Configure the system

### Fstab

Generate an fstab file (use -U or -L to define by UUID or labels, respectively):

```

genfstab -U /mnt >> /mnt/etc/fstab

```

Check the resulting /mnt/etc/fstab file, and edit it in case of errors.

### Chroot

Change root into the new system:

```

arch-chroot /mnt

```

### Time zone

Set the time zone:

```

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime

```

Run hwclock(8) to generate /etc/adjtime:

```

hwclock --systohc

```

This command assumes the hardware clock is set to UTC. See System time#Time standard for details.

### Localization

Edit /etc/locale.gen and uncomment en_US.UTF-8 UTF-8 and other needed locales. Generate the locales by running:

```

locale-gen

```

Create the locale.conf(5) file, and set the LANG variable accordingly:

```

/etc/locale.conf LANG=en_US.UTF-8

```

If you set the console keyboard layout, make the changes persistent in vconsole.conf(5):

```

/etc/vconsole.conf KEYMAP=de-latin1

```

### Network configuration

Create the hostname file:

```

/etc/hostname myhostname

```

Add matching entries to hosts(5):

```

/etc/hosts 127.0.0.1   localhost ::1         localhost 127.0.1.1   myhostname.localdomain   myhostname

```

If the system has a permanent IP address, it should be used instead of 127.0.1.1.

Complete the network configuration for the newly installed environment, that may include installing suitable network management software.

### Initramfs

Creating a new initramfs is usually not required, because mkinitcpio was run on installation of the kernel package with pacstrap.

For LVM, system encryption or RAID, modify mkinitcpio.conf(5) and recreate the initramfs image:

```

mkinitcpio -P

```

### Root password

Set the root password:

```

passwd

```

### Boot loader

Choose and install a Linux-capable boot loader. If you have an Intel or AMD CPU, enable microcode updates in addition.

## Reboot

Exit the chroot environment by typing exit or pressing Ctrl+d.

Optionally manually unmount all the partitions with umount -R /mnt: this allows noticing any "busy" partitions, and finding the cause with fuser(1).

Finally, restart the machine by typing reboot: any partitions still mounted will be automatically unmounted by systemd. Remember to remove the installation medium and then login into the new system with the root account.

## Post-installation

See General recommendations for system management directions and post-installation tutorials (like creating unprivileged user accounts, setting up a graphical user interface, sound management or touchpad support).

For a list of applications that may be of interest, see List of applications.

## See also
- Getting and installing Arch
- Arch Linux on the move
- Arch in the cloud
