{ ... }:

{
  time.timeZone = "Europe/Lisbon";

  users.groups.dbus-monitor = { };

  users.users.wh1le = {
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
    ];
  };

  # users.users.work = {
  #   isNormalUser = true;
  #
  #   extraGroups = [
  #     "wheel"
  #     "audio"
  #     "video"
  #     "input"
  #     "tss"
  #     "plugdev"
  #     "render"
  #     "docker"
  #     "kvm"
  #     "podman"
  #     "dbus-monitor"
  #     "networkmanager"
  #   ];
  # };
}
