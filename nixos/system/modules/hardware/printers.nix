{ pkgs, ... }:
{

  services = {
    colord.enable = true;

    printing = {
      enable = true;
      drivers = [
        pkgs.cups-filters
        pkgs.epson-escpr
        pkgs.epson-escpr2
      ];
      # Remove listenAddresses entirely - defaults to localhost + socket
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = false;
    };
  };
}
