# Install Commands

Temp doc for quick access to commands for testing

git clone --recurse-submodules https://github.com/wh1le/dot-hutch.git ~/dot/dot-hutch

sudo nix --experimental-features "nix-command flakes" \
 run github:nix-community/disko -- --mode disko \
 --flake "$HOME/dot/dot-hutch#thinkpad"

nix --extra-experimental-features "nix-command flakes" \
 shell nixpkgs#age nixpkgs#sops \
 --command $HOME/dot/dot-hutch/scripts/deploy-empty-sops.sh

sudo nixos-install --flake "$HOME/dot/dot-hutch#thinkpad"

mkdir -p /mnt/home/wh1le/dot

cp -rf ~/dot/dot-hutch /mnt/home/wh1le/dot/

sudo rm -rf /mnt/etc/nixos
sudo ln -sfn /mnt/home/wh1le/dot/dot-hutch /mnt/etc/nixos

sudo nixos-enter --root /mnt

passwd wh1le
