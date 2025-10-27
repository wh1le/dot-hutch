{ config, lib, self, ... }:

let
  KHOLE_IP = "192.168.1.253";
  KHOLE_UNBOUND_PORT = "53";
in
{
  sops.secrets = {
    pihole_password_file = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole/pihole/password";
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/run/secrets/pihole_password_file";
    };
  };

  services.resolved.enable = false;
  services.dnsmasq.enable = lib.mkForce false;

  networking.firewall.allowedTCPPorts = [ 53 80 ];
  networking.firewall.allowedUDPPorts = [ 53 67 ];

  systemd.tmpfiles.rules = [
    "d /pi-hole/data/etc-pihole     0755 root root - -"
    "d /pi-hole/data/etc-dnsmasq.d  0755 root root - -"
  ];

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
      "${config.sops.secrets.pihole_password_file.path}:/run/secrets/webpassword"
    ];

    environment = {
      TZ = "Europe/Lisbon";
      DNSMASQ_USER = "root";
      DNS1 = "${KHOLE_IP}#${KHOLE_UNBOUND_PORT}";
      DNS2 = "";
      WEBPASSWORD_FILE = "/run/secrets/webpassword";
      ServerIP = KHOLE_IP;
      DNSMASQ_LISTENING = "all";
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cpus=0.5"
      "--memory=256m"
      "--network=host"
    ];
  };
}
