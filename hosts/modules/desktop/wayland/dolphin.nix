{ pkgs, ... }:
{

  # Forces GTK apps to use XDG Desktop Portals for file pickers, screenshots, screen sharing, etc.:w
  environment.variables.GTK_USE_PORTAL = "1";

  services.gvfs.enable = true;

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
    # kdePackages.qt6gtk2
    # at-spi2-atk # accessibility bridge, safe and used by Qt/GTK apps
  ];

  # TODO: proposed optimal packages, consider them if want to switch
  # environment.systemPackages = with pkgs; [
  #   # Core Dolphin
  #   kdePackages.polkit-kde-agent-1
  #   kdePackages.dolphin
  #   kdePackages.kio
  #   kdePackages.kio-extras
  #   kdePackages.qtwayland
  #
  #   # Optional viewers (keep what you use)
  #   kdePackages.ark # Archive manager
  #   kdePackages.gwenview # Image viewer
  #   kdePackages.okular # PDF viewer
  #   kdePackages.ffmpegthumbs # Video thumbnails
  #   kdePackages.kdegraphics-thumbnailers # Image thumbnails
  # ];
}
