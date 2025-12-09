{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "kde";
    # style = "Breeze";
  };

  environment.sessionVariables.QT_QPA_PLATFORM = "wayland";

  services.desktopManager.plasma6.enable = true;

  services.dbus.packages = [
    pkgs.kdePackages.kded
    pkgs.kdePackages.plasma-workspace
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.polkit-kde-agent-1 # authentication
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.kio-admin
    kdePackages.kde-cli-tools
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kservice
    kdePackages.systemsettings
    kdePackages.qtwayland
    kdePackages.kde-cli-tools
    # qt6.qtwayland # Qt6 Wayland platform plugin
    egl-wayland
    qt6.qtwayland
    kdePackages.qt6gtk2
    # kdePackages.qt6.full TODO: got removed 25.11 replace with new dependencies

    shared-mime-info # database of common mime types
    desktop-file-utils

    at-spi2-atk # accessibility bridge, safe and used by Qt/GTK apps

    cliphist
    gifsicle # GIF optimization
  ];
}
