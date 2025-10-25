{ config, lib, ... }:
{
  services.resolved.enable = false;
  services.dnsmasq.enable = lib.mkForce false;

  networking.firewall.allowedTCPPorts = [
    53
    80
  ];
  networking.firewall.allowedUDPPorts = [
    53
    67
  ];

  systemd.tmpfiles.rules = [
    "d /pi-hole/data/etc-pihole     0755 root root - -"
    "d /pi-hole/data/etc-dnsmasq.d  0755 root root - -"
  ];

  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  # services.resolved.enable = false;
  # services.dnsmasq.enable = lib.mkForce false;

  virtualisation.oci-containers.containers.pi-hole = {
    image = "pihole/pihole:latest";
    autoStart = true;

    ports = [
      "53:53/tcp"
      "53:53/udp"
      "80:80/tcp"
    ];

    volumes = [
      "/pi-hole/data/etc-pihole:/etc/pihole"
      "/pi-hole/data/etc-dnsmasq.d:/etc/dnsmasq.d"
    ];

    environment = {
      TZ = config.time.timeZone;
      DNSMASQ_USER = "root";
    };
    # environmentFiles = [ "/run/keys/pihole.env" ]; # WEBPASSWORD=...
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cpus=0.5"
      "--memory=256m"
    ];
  };

}
