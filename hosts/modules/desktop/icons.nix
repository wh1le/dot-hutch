{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.papirus-icon-theme # pick your pack
    pkgs.dconf
    pkgs.gsettings-desktop-schemas
    pkgs.libsForQt5.qt5ct
    pkgs.qt6ct
  ];

  programs.dconf.enable = true;
  services.dbus.enable = true;
}
