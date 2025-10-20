{ settings, pkgs, ... }:

{
  users.users.${settings.mainUser}.extraGroups = [
    "docker"
    "kvm"
  ];

  virtualisation.docker.enable = true;

  virtualisation.docker.storageDriver = "overlay2";
  virtualisation.docker.daemon.settings.experimental = true;

  virtualisation.podman.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    distrobox
    libvirt
    qemu

    wine
    wine64
    winetricks
  ];
}
