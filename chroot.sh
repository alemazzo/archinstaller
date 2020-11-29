

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

echo "Setup password for root user"
read
passwd

echo "Create user ${username} group wheel"
read
useradd -m -G wheel "${username}"

echo "setup password for ${username}"
read
passwd ${username}

echo "Added wheel to sudo"
read
echo "%wheel ALL=(ALL) ALL" | EDITOR='tee -a' visudo


echo "Enable sddm"
read
systemctl enable sddm.service

echo "Enable NetworkManager"
read
systemctl enable NetworkManager.service

echo "


************
* FINISHED *
************
"
