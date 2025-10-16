{
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # boot.initrd.systemd.enable = true;
  # boot.initrd.availableKernelModules = [
  #   "ahci"
  #   "sd_mod"
  #   "sr_mod"
  #   "usbhid"
  #   "xhci_hcd"
  #   "evdev"
  # ];

  environment.systemPackages = with pkgs; [
    # TODO: decide on package
    blueman
    bluez
    bluetui

    overskride
  ];
}
