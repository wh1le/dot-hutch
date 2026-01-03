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
    pkgs.hyprpolkitagent
    unstable.openssl

    unstable.cryptsetup # luks

    unstable.git-crypt
    unstable.git-remote-gcrypt
  ];
}
