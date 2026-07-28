{ pkgs
, ...
}:
{
  # 1. Add the udev rule
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev",
    KERNEL=="i2c-5",
    GROUP="video",
    MODE="0660"
  '';

  environment.systemPackages = with pkgs; [
    paperlike-go
  ];
}
