sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake /tmp/Code/dot-hutch#homepc

sudo nixos-install --flake /tmp/Code/dot-hutch#homepc --no-root-passwd

sudo cp -r /tmp/Code /mnt/home/wh1le/Code
sudo chown -R 1000:1000 /mnt/home/wh1le/Code

## Set root pass after reboot

sudo cryptsetup open /dev/nvme0n1p2 encrypted
sudo vgchange -ay pool
sudo mount /dev/pool/root /mnt
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo nixos-enter --root /mnt
passwd wh1le

## After reboot

sudo rm -rf /etc/nixos
sudo ln -s /home/wh1le/Code/dot-personal /etc/nixos
