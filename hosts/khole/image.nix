{ modulesPath, lib, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  sdImage.compressImage = false;

  # system.copySystemConfiguration = lib.mkForce true;
  # fileSystems."/".device = lib.mkForce "/dev/disk/by-uuid/6462-6639";
  # fileSystems."/".device = lib.mkForce "/dev/disk/by-uuid/NIXOS";
}
