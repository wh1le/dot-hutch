{
  pkgs,
  lib,
  ...
}:

{
  system.stateVersion = "25.05";

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  imports = [
    ../../modules/bluetooth.nix
    ../../modules/browser.nix
    ../../modules/desktop.nix
    ../../modules/fonts.nix
    ../../modules/games.nix
    ../../modules/images.nix
    ../../modules/languages.nix
    ../../modules/mime_types.nix
    ../../modules/network.nix
    ../../modules/nvidia.nix
    ../../modules/nvim.nix
    ../../modules/paperlike.nix
    ../../modules/printers.nix
    ../../modules/security.nix
    ../../modules/audio.nix
    ../../modules/streaming.nix
    ../../modules/terminal.nix
    ../../modules/users.nix
    ../../modules/vpn.nix
    ../../modules/wayland.nix
    # ../../modules/wine.nix
    ../../modules/xserver.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "vmd"
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        copyKernels = false;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = with pkgs; [
    usbutils
    libinput
  ];
}
