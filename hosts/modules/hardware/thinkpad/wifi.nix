{ pkgs, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        backend = "iwd";
      };
    };
    wireless.iwd.enable = true;
  };

  hardware.firmware = [ pkgs.linux-firmware ];
}
