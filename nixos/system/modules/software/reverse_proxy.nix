{ ... }:
{
  services.caddy = {
    enable = true;

    globalConfig = ''
      auto_https off
    '';

    virtualHosts."router.local".extraConfig = ''
      reverse_proxy http://192.168.1.254
    '';

    virtualHosts."asus.local".extraConfig = ''
      reverse_proxy http://192.168.50.1
    '';

    virtualHosts."pihole.local".extraConfig = ''
      reverse_proxy http://192.168.50.2
    '';
  };

  networking.hosts."192.168.50.1" = [ "asus.local" ];
  networking.hosts."192.168.50.2" = [ "pihole.local" ];
  networking.hosts."192.168.1.254" = [ "router.local" ];
}
