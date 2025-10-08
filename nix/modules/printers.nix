{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = [
        pkgs.cups-filters
        pkgs.epson-escpr
        pkgs.epson-escpr2
      ];
      listenAddresses = [ "localhost:631" ];
    };

    caddy = {
      enable = true;
      virtualHosts."printers.local".extraConfig = ''
        reverse_proxy 127.0.0.1:631
      '';
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  networking.extraHosts = ''
    127.0.0.1 printers.local
  '';
}
