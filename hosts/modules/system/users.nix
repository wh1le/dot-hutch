{ settings, ... }:

{
  time.timeZone = settings.timezone;

  users.users.${settings.mainUser} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "tss"
      "plugdev"
    ];
  };
}
