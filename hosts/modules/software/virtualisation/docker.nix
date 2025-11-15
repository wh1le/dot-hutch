{ pkgs, lib, ... }:
{
  # virtualisation.containers.storage.settings = {
  #   storage = {
  #     driver = "btrfs";
  #     runroot = "/run/containers/storage";
  #     graphroot = "/var/lib/containers/storage";
  #     options.overlay.mountopt = "nodev,metacopy=on";
  #   };
  # };

  # Add 'newuidmap' and 'sh' to the PATH for users' Systemd units.
  # Required for Rootless podman.
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [ pkgs.bash ]}"
  '';

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";
  virtualisation.docker.daemon.settings.experimental = true;

  users.users.wh1le.extraGroups = [
    "docker"
  ];

  environment.systemPackages = [
    pkgs.distrobox
    pkgs.docker-compose
    pkgs.dive # look into docker image layers
  ];
}
