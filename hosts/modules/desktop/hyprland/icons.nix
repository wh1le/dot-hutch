{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.bibata-cursors
    # pkgs.papirus-icon-theme
    # pkgs.colloid-icon-theme

    # TODO: remove me
    # pkgs.gsettings-desktop-schemas
    # pkgs.libsForQt5.qt5ct
    # pkgs.qt6ct
  ];

}
