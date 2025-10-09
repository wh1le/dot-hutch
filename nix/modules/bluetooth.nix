{
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "ahci"
    "sd_mod"
    "sr_mod"
    "usbhid"
    "xhci_hcd"
    "evdev"
  ];
  # boot.kernelModules = [
  #   "uhid"
  #   "hid_apple"
  # ];

  environment.systemPackages = with pkgs; [
    blueman
    bluez
    bluetui
  ];
}
