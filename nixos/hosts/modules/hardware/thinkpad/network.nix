{ pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = false;
      # backend = "iwd";
    };
  };

  # networking.wireless.iwd.enable = true;
  # networking.wireless.iwd.settings = {
  #   Network = {
  #     EnableIPv6 = true;
  #   };
  #   Settings = {
  #     AutoConnect = true;
  #   };
  # };

  hardware.firmware = [ pkgs.linux-firmware ];

  networking.timeServers = [ "0.nixos.pool.ntp.org" ];

  networking.wireless.extraConfig = ''country=PT'';
}
