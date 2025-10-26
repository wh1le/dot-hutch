{ inputs, ... }:

{
  time.timeZone = "Europe/Lisbon";

  users.users.wh1le = {
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
