{
  modulesPath,
  pkgs,
  ...
}:
{
  system.stateVersion = "25.05";

  services.timesyncd.enable = true;
  services.timesyncd.servers = [
    "162.159.200.1"
    "162.159.200.123"
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    ./modules/image.nix
    ./modules/network.nix
    ./modules/desktop.nix
    ./modules/ssh.nix
    ./modules/unbound.nix
    ./modules/user.nix
    ./modules/sops.nix
    ./modules/virtualisation.nix
    ./modules/containers/pi-hole.nix

    ../modules/security/firewall.nix
    ../modules/system/locales.nix
  ];
}
