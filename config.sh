

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

username=alessandro