#!/bin/bash

# SUGGESTED PARTITION SCHEME
# ==========================
# DEVICE       TYPE                            SIZE
# /dev/sda1    EFI System                      500MiB
# /dev/sda2    Arch-Linux                      Remaining Space


settings=(
    keymap,"Keymap"
    locale,"Locale"
    num_partition,"Number_of_Partitions"
)
# Partitioning
efi_partition=/dev/sda1
efi_partition_size=512M

linux_partition=/dev/sda2

# File System Structure
efi_directory=/boot/efi
bootloader_id=GRUB
target=x86_64-efi

# General config
keymap=it
locale='en_US.UTF-8 UTF-8'
lang='en_US.UTF-8'
region=Europe
location=Rome
hostname=Matebook
username=alessandro

# Packages
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
    util-linux
    xorg
    kde-applications  
    plasma
    plasma-wayland-session
)

num_partition=2


# Setup a single configuration
# The first parameter should be the name of the variable
# The second parameter should be the hint
set_conf(){
    echo -n "$2 [Default : ${!1}] : ";
    read value;
    if [[ ! -z ${value} ]]; then
        eval "$1=$value";
        # $1=$value;
    fi;
}


for i in ${settings[@]}; do IFS=","; set -- $i; 
    echo "------------------------------------"
    set_conf $1 $2;
    eval 'echo \> $1 : ${!1}';
done;
echo "------------------------------------"
