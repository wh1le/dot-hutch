{ config, lib, pkgs, modulesPath, ... }:
let
  swap_drive = "/dev/disk/by-uuid/660e220f-ab87-4b0c-ab85-3249468a5487";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  services.fwupd.enable = true;

  boot.initrd = {
    enable = true;
    availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ ];
  };

  boot.kernelParams = [
    "resume=${swap_drive}"
    "amd_iommu=on" # Already have amd_pstate=active elsewhere
    "iommu=pt" # Passthrough mode, helps with wake
    "acpi_osi=Linux" # Better ThinkPad ACPI support
    "acpi_backlight=native"
    # "video.brightness_switch_enabled=0"
  ];

  boot.resumeDevice = swap_drive;
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a779eb63-1521-41b6-a616-72362c1afe0b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BD95-BDFE";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{ device = swap_drive; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = [
    pkgs.lshw
  ];
}

