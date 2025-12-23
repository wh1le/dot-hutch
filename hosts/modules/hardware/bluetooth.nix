{ pkgs
, ...
}:
{

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

  environment.systemPackages = with pkgs; [
    # blueman
    bluez
    bluetui

    overskride
  ];
}
