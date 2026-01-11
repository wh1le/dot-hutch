{ ... }: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "searx.local".extraConfig = "reverse_proxy http://localhost:8882";
      "syncthing.local".extraConfig = "reverse_proxy http://localhost:8384";
      "printing.local".extraConfig = "reverse_proxy http://localhost:631";

      "ips.local".extraConfig = "reverse_proxy http://192.168.1.254";
      "asus.local".extraConfig = "reverse_proxy http://192.168.50.1";
      "pihole.local".extraConfig = "reverse_proxy http://192.168.50.2";
    };
  };

  networking.hosts = {
    "127.0.0.1" = [
      "searx.local"
      "ips.local"
      "asus.local"
      "pihole.local"
      "syncthing.local"
      "printing.local"
    ];
  };
}
