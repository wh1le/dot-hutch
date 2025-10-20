{ pkgs, ... }:
{
  services.fwupd.enable = true;

  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  environment.variables.QT_ENABLE_HIGHDPI_SCALING = 1;
  # environment.variables.QT_SCALE_FACTOR = 2;
  environment.variables.QT_AUTO_SCREEN_SCALE_FACTOR = 1; # you can only pick one QT_AUTO_SCREEN_SCALE_FACTOR or QT_SCALE_FACTOR
  environment.variables.MOZ_ENABLE_WAYLAND = 1;

  environment.variables.QT_QPA_PLATFORM = "wayland";
  # environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
  # environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kde-cli-tools
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kwallet # passwords
    xdg-utils

    # Consider to remove
    # kdePackages.qtstyleplugin-kvantum # styling

    # kdePackages.qtwayland
    # libsForQt5.qt5.qtwayland
    # libsForQt5.plasma-wayland-protocols
    #
    # kdePackages.qt6ct # configuration
    # libsForQt5.qt5ct # configuration
    # libsForQt5.qtstyleplugin-kvantum

    # qt6.qtwayland # Qt6 Wayland platform plugin
    # libsForQt5.qt5.qtwayland # Qt5 Wayland platform plugin
    # kdePackages.polkit-kde-agent-1 # some polkit agent is required

    shared-mime-info # database of common mime types
    desktop-file-utils

    at-spi2-atk # accessibility bridge, safe and used by Qt/GTK apps
    # playerctl # media key control; works with KDE media players

    cliphist
    gifsicle # GIF optimization
  ];
}
