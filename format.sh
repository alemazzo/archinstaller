echo "g
n
1

+512M
t
1
n
2


w
" | fdisk /dev/sda

mkfs.fat -F32 ${efi_partition}
mkfs.ext4 ${linux_partition}