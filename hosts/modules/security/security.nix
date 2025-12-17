{ pkgs, unstable, ... }:
{
  security.sudo.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;

  security.pam.services.hyprlock = { };
  environment.sessionVariables = {
    LOCKER = "${pkgs.hyprlock}/bin/hyprlock";
  };

  environment.systemPackages = [
    unstable.openssl
    pkgs.hyprpolkitagent
  ];
}
