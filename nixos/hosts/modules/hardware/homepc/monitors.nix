{ pkgs, ... }: {
  hardware.i2c.enable = true;


  users.users.wh1le.extraGroups = [ "i2c" ];

  environment.systemPackages = [
    pkgs.ddcutil
  ];
}
