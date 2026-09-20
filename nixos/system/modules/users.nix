{ config, ... }:

{
  users.groups = {
    dbus-monitor = { };
    secrets = { };
    ydotool = { };
  };

  users.users.${config.my.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "tss"
      "plugdev"
      "render"
      "dbus-monitor"
      "networkmanager"
      "keyd"
      "secrets"
      "libvirtd"
      "ydotool"
      "scanner"
      "lp"
      # "input"
      # "docker"
      # "kvm"
      # "podman"
    ];
  };
}
