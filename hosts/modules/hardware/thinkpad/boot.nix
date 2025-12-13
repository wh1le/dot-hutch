{ pkgs, lib, config, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # services.firmware.enable = true;

  # Recommendation for thinkpad if it doesn't completely turns off
  boot.kernelParams = [ "apm=power_off" ];
  boot.extraModulePackages = [ ];

  boot.kernelModules = [ "hid_apple" "kvm-amd" "btusb" "thinkpad_acpi" ];

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0 fnmode=2
    options thinkpad_acpi fan_control=1
  '';

  boot.initrd = {
    systemd.enable = true;
    kernelModules = [ "amdgpu" ]; # early KMS for 780M
    availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "thunderbolt" # if USB4/TB present
    ];
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    timeout = 2;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
