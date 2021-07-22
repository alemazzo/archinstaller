

echo "Settings keys = ${keymap}"
loadkeys ${keymap}

echo "Setting time"
timedatectl set-ntp true

echo "

Partitioning : Press a key to proceed"
read

echo "g
n
1

+${efi_partition_size}
t
1
n
2


w
" | fdisk /dev/sda

echo "

Formatting, press a key to proceed"
read
mkfs.fat -F32 ${efi_partition}
mkfs.ext4 ${linux_partition}

echo "Mounting ${linux_partition} in /mnt"
mount ${linux_partition} /mnt

echo "Mkdir /mnt${efi_directory}"
mkdir -p /mnt${efi_directory}

echo "Mounting ${efi_partition} in /mnt${efi_directory}"
mount ${efi_partition} /mnt${efi_directory}

echo "Install packages: "
for pack in ${packages[@]}; do
    echo "${pack}"
done; 
pacstrap /mnt ${packages[@]}

echo "Generating fstab: genfstab -U /mnt >> /mnt/etc/fstab"
genfstab -U /mnt >> /mnt/etc/fstab


echo "Generate chroot-install.sh"

echo "#\!/bin/bash" > /mnt/chroot-install.sh
cat config.sh >> /mnt/chroot-install.sh
cat chroot.sh >> /mnt/chroot-install.sh

chmod +x /mnt/chroot-install.sh

echo "Chroot on /mnt and execute chroot-install.sh"
arch-chroot /mnt /chroot-install.sh

