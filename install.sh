#!/bin/bash

# SUGGESTED PARTITION SCHEME
# ==========================
# DEVICE       TYPE                            SIZE
# /dev/sda1    EFI System                      500MiB
# /dev/sda2    Arch-Linux                      Remaining Space

# Partitioning
efi_partition=/dev/sda1
efi_partition_size=512M

linux_partition=/dev/sda2

# File System Structure
efi_directory=/boot/efi
bootloader_id=GRUB
target=x86_64-efi

keymap=it
locale='en_US.UTF-8 UTF-8'
lang='en_US.UTF-8'
region=Europe
location=Rome
hostname=Matebook

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


loadkeys ${keymap}
timedatectl set-ntp true

# Partition
# Format

mount ${linux_partition} /mnt
mkdir -p /mnt${efi_directory}
mount ${efi_partition} /mnt${efi_directory}

pacstrap /mnt  ${packages[@]}

genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/${region}/${location} /etc/localtime
hwclock --systohc
echo ${locale} >> /etc/locale.gen
locale-gen
echo 'LANG=${lang}' >> /etc/locale.conf
echo 'KEYMAP=${key}' >> /etc/vconsole.conf

echo '${hostname}' > /etc/hostname

echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${hostname}.localdomain ${hostname}   
" >> /etc/hosts

mkinitcpio -P
grub-install --target=${target} --efi-directory=${efi_directory} --bootloader-id=${bootloader_id}
grub-mkconfig -o /boot/grub/grub.cfg

# Set passwd for root
# Add user and set passwd and create home folder
# Add sudo privileges to the user
