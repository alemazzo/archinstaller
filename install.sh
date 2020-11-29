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

echo "Settings keys = ${keymap}"
read;
loadkeys ${keymap}

echo "Setting time"
read;
timedatectl set-ntp true

# Partition
# Format

echo "Mounting ${linux_partition} in /mnt"
read
mount ${linux_partition} /mnt

echo "Mkdir /mnt${efi_directory}"
read
mkdir -p /mnt${efi_directory}

echo "Mounting ${efi_partition} in /mnt${efi_directory}"
read
mount ${efi_partition} /mnt${efi_directory}

echo "Install packages:"
for pack in ${packages[@]};
    echo "${pack}"
done; 
read
pacstrap /mnt ${packages[@]}

echo "Generating fstab: genfstab -U /mnt >> /mnt/etc/fstab"
read
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chroot on /mnt"
read
arch-chroot /mnt

echo "Link time ${region}/${location} to /etc/localtime"
read
ln -sf /usr/share/zoneinfo/${region}/${location} /etc/localtime

echo "hwclock --systohc"
read
hwclock --systohc

echo "Add ${locale} to /etc/locale.gen"
read
echo ${locale} >> /etc/locale.gen

echo "Run locale-gen"
read
locale-gen

echo "Add LANG=${lang} to /etc/locale.conf"
read
echo 'LANG=${lang}' >> /etc/locale.conf

echo "Add KEYMAP=${key} to /etc/vconsole.conf"
read
echo 'KEYMAP=${key}' >> /etc/vconsole.conf

echo "Add ${hostname} to /etc/hostname"
read
echo '${hostname}' > /etc/hostname

echo "Setup /etc/hosts"
read
echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${hostname}.localdomain ${hostname}   
" >> /etc/hosts

echo "mkinitcpio -P"
read
mkinitcpio -P

echo "GRUB_INSTALL : target=${target} efi-directory=${efi_directory} bootloader-id=${bootloader_id}"
read
grub-install --target=${target} --efi-directory=${efi_directory} --bootloader-id=${bootloader_id}

echo "MKCONFIG : -o /boot/grub/grub.cfg"
read
grub-mkconfig -o /boot/grub/grub.cfg

# Set passwd for root
# Add user and set passwd and create home folder
# Add sudo privileges to the user
