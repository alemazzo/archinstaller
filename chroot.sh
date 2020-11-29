

echo "Link time ${region}/${location} to /etc/localtime"
ln -sf /usr/share/zoneinfo/${region}/${location} /etc/localtime

echo "hwclock --systohc"
hwclock --systohc

echo "Add ${locale} to /etc/locale.gen"
echo ${locale} >> /etc/locale.gen

echo "Run locale-gen"
locale-gen

echo "Add LANG=${lang} to /etc/locale.conf"
echo 'LANG=${lang}' >> /etc/locale.conf

echo "Add KEYMAP=${key} to /etc/vconsole.conf"
echo 'KEYMAP=${key}' >> /etc/vconsole.conf

echo "Add ${hostname} to /etc/hostname"
echo '${hostname}' > /etc/hostname

echo "Setup /etc/hosts"
echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${hostname}.localdomain ${hostname}   
" >> /etc/hosts

echo "mkinitcpio -P"
mkinitcpio -P

echo "GRUB_INSTALL : target=${target} efi-directory=${efi_directory} bootloader-id=${bootloader_id}"
grub-install --target=${target} --efi-directory=${efi_directory} --bootloader-id=${bootloader_id}

echo "MKCONFIG : -o /boot/grub/grub.cfg"
grub-mkconfig -o /boot/grub/grub.cfg

echo "Setup password for root user"
passwd

echo "Create user ${username} group wheel"
useradd -m -G wheel "${username}"

echo "setup password for ${username}"
passwd ${username}

echo "Added wheel to sudo"
echo "%wheel ALL=(ALL) ALL" | EDITOR='tee -a' visudo


echo "Enable sddm"
systemctl enable sddm.service

echo "Enable NetworkManager"
systemctl enable NetworkManager.service

echo "


************
* FINISHED *
************
"
