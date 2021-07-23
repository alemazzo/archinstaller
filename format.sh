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

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2