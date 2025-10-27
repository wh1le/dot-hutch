{ lib, config, ... }:

{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  hardware.enableRedistributableFirmware = true;

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };
}
