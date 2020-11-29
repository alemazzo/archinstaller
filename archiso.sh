

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

echo "Install packages: "
for pack in ${packages[@]}; do
    echo "${pack}"
done; 
read
pacstrap /mnt ${packages[@]}

echo "Generating fstab: genfstab -U /mnt >> /mnt/etc/fstab"
read
genfstab -U /mnt >> /mnt/etc/fstab


echo "Generate chroot-install.sh"

echo "#\!/bin/bash" > /mnt/chroot-install.sh
cat config.sh >> /mnt/chroot-install.sh
cat chroot.sh >> /mnt/chroot-install.sh

chmod +x /mnt/chroot-install.sh

echo "Chroot on /mnt and execute chroot-install.sh"
read
arch-chroot /mnt /chroot-install.sh