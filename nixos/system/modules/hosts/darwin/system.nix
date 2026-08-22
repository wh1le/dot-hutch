{ config, ... }:
{
  system.primaryUser = config.my.username;

  networking.computerName = "mac";
  networking.localHostName = "mac";

  users.users.${config.my.username}.home = "/Users/${config.my.username}";

  nix.enable = false;
  system.startup.chime = false;
}
