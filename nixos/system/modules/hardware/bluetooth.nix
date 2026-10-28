{ pkgs, ... }: {

  hardware.firmware = [ pkgs.rtl8761b-firmware ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  systemd.services.bluetooth.serviceConfig = {
    ProtectKernelLogs = true;
    ProtectHostname = true;
  };

  environment.systemPackages = with pkgs; [
    # blueman
    bluez
    bluetui

    overskride
  ];
}
