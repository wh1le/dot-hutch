{ config, pkgs, ... }:
let
  home = config.users.users.${config.my.username}.home;
in
{
  environment.sessionVariables.PASSWORD_STORE_DIR = "$HOME/.secrets/passwords";
  services.passSecretService.enable = true;

  systemd.user.services."dbus-org.freedesktop.secrets".serviceConfig.ExecStart = [
    ""
    "${config.services.passSecretService.package}/bin/pass_secret_service --path ${home}/.secrets/passwords"
  ];

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    settings = {
      default-cache-ttl = 600;
      max-cache-ttl = 3600;
    };
  };

  systemd.tmpfiles.rules = [
    "d ${home}/.gnupg 0700 ${config.my.username} users -"

    "d ${home}/.secrets 750 root secrets -"
    "d ${home}/.secrets/passwords 700 ${config.my.username} users -"
    "d ${home}/.secrets/files 700 ${config.my.username} users -"
    "z ${home}/.secrets/vpn 750 root secrets -"
  ];

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-gnome3
    pinentry-curses # pinentry

    (pkgs.pass.withExtensions (exts: [
      exts.pass-import
      exts.pass-update
      exts.pass-otp
    ]))
  ];
}
