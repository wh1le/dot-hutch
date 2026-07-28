{ pkgs, config, lib, ... }:
let
  humanUsers = lib.attrNames (lib.filterAttrs (name: user: user.isNormalUser) config.users.users);
  homeOf = user: config.users.users.${user}.home;

  sharedJobs = user: [
    "*/5 * * * * ${user} ${homeOf user}/.local/bin/public/system-pass-sync-repos"
    "0 1 */5 * * ${user} ${pkgs.trash-cli}/bin/trash-empty"
  ];

  guiJobs = user: [
    "0 */5 * * * ${user} DISPLAY=:0 XAUTHORITY=${homeOf user}/.Xauthority ${pkgs.copyq}/bin/copyq removeall"
  ];
in
{
  services.cron = {
    enable = true;
    systemCronJobs = lib.concatMap sharedJobs humanUsers ++ guiJobs config.my.username;
  };
}
