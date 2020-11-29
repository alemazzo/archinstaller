#!/bin/bash

# SUGGESTED PARTITION SCHEME
# ==========================
# DEVICE       TYPE                            SIZE
# /dev/sda1    EFI System                      500MiB
# /dev/sda2    Arch-Linux                      Remaining Space


packages=(
    base 
    base-devel 
    linux-lts 
    linux-firmware 
    amd-ucode 
    vim 
    grub
    efibootmgr
    networkmanager
)


loadkeys it
timedatectl set-ntp true

# Partition
# Format
# Mount

pacstrap /mnt  packages[@]

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
echo 'KEYMAP=it' >> /etc/vconsole.conf

echo 'Matebook' > /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   Matebook.localdomain Matebook   
" >> /etc/hosts

mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Set passwd for root
# Add user and set passwd and create home folder
# Add sudo privileges to the user
