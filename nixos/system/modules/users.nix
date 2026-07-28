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
      "input"
      "tss"
      "plugdev"
      "video"
      "render"
      "docker"
      "kvm"
      "podman"
      "dbus-monitor"
      "networkmanager"
      "keyd"
      "secrets"
      "libvirtd"
      "ydotool"
      "scanner"
      "lp"
    ];
  };
}
