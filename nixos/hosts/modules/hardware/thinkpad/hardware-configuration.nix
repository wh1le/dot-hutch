{ config, lib, pkgs, modulesPath, ... }:
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
    "amd_iommu=on" # Already have amd_pstate=active elsewhere
    "iommu=pt" # Passthrough mode, helps with wake
    "acpi_osi=Linux" # Better ThinkPad ACPI support
    "acpi_backlight=native"
    # "video.brightness_switch_enabled=0"
  ];

  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = [
    pkgs.lshw
    # pkgs.libinput-gestures
  ];
}

