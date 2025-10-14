{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  system.stateVersion = "25.05";

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44b4a5fa-e13f-4a1c-a7d1-a5499a0803a2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2F34-5D71";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # nix.settings = {
  #   max-jobs = "auto";
  #   cores = 0;
  # };

  swapDevices = [ { device = "/dev/disk/by-uuid/9572a97b-f3aa-408d-aad5-bdcaeb019c91"; } ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../modules/bluetooth.nix
    ../modules/browser.nix
    ../modules/desktop.nix
    ../modules/fonts.nix
    ../modules/images.nix
    ../modules/languages.nix
    ../modules/mime_types.nix
    ../modules/network.nix
    ../modules/nvidia.nix
    ../modules/nvim.nix
    ../modules/paperlike.nix
    ../modules/security.nix
    ../modules/audio.nix
    ../modules/terminal.nix
    ../modules/users.nix
    ../modules/vpn.nix
    ../modules/hyprland.nix
    ../modules/icons.nix
    ../modules/xserver.nix
    ../modules/filesystem.nix
    ../modules/video.nix
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
    socat
  ];
}
