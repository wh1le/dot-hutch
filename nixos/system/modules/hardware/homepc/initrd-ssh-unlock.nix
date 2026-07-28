# sudo mkdir -p /etc/secrets/initrd
# sudo ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key

{ pkgs, ... }:
let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDNgfmGm6cqKhLT+baeLK5pyEiYM0fSHYPE8Ir14Ouw"
  ];
  hostKeyPath = "/etc/secrets/initrd/ssh_host_ed25519_key";
in
{
  system.activationScripts.initrdSshHostKey = {
    text = ''
      if [ ! -e ${hostKeyPath} ]; then
        mkdir -p "$(dirname ${hostKeyPath})"
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f ${hostKeyPath}
      fi
    '';
  };

  boot.initrd = {
    # match module with:
    # lspci -v | grep -iA3 ethernet | grep -i "kernel driver\|ethernet"
    availableKernelModules = [ "igc" ];

    systemd.network.enable = true;
    systemd.network.networks."10-initrd-wired" = {
      matchConfig.Name = "en*";
      networkConfig.DHCP = "yes";
    };

    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 1234;
        authorizedKeys = authorizedKeys;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      };
    };
  };
}
