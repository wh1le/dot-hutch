{ pkgs }:
{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.cups-filters
      pkgs.epson-escpr
      pkgs.epson-escpr2
    ];

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
