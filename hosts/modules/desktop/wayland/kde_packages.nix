{ pkgs, ... }:
{
  # environment.variables.QT_SCALE_FACTOR = 2;
  # environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
  # environment.variables.QT_QPA_PLATFORMTHEME = "qt6ct";

  # environment.etc."xdg/menus/applications.menu".source =
  # "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  # environment.variables.XDG_MENU_PREFIX = "plasma-";

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

    # TODO: Consider to remove
    # kdePackages.qtstyleplugin-kvantum # styling
    # kdePackages.qtwayland
    # libsForQt5.qt5.qtwayland
    # libsForQt5.plasma-wayland-protocols
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
