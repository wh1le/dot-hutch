{ modulesPath, lib, ... }:

{
  # https://nixos.wiki/wiki/NixOS_on_ARM#Installation
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  sdImage.compressImage = false;

  # system.copySystemConfiguration = lib.mkForce true;

  fileSystems."/".device = lib.mkForce "/dev/disk/by-uuid/6462-6639";
}
