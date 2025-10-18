{ pkgs, ... }:
{
  # programs.plasma.enable = true;
  services.fwupd.enable = true;
  services.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kde-cli-tools
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    kdePackages.polkit-kde-agent-1
    kdePackages.kdeconnect
    kdePackages.qt6ct

    qt6.qtwayland
    qt5.qtwayland

    shared-mime-info
    desktop-file-utils
    kwallet # passwords
    at-spi2-atk # accessibility bridge, safe and used by Qt/GTK apps
    playerctl # media key control; works with KDE media players
    psmisc # provides 'killall', 'pstree', general utilities
    imagemagick # image conversion, used by many KDE apps
    ffmpeg_6-full # full multimedia backend for thumbnails, video
    wl-clipboard # Wayland clipboard integration
    wl-clip-persist # keeps clipboard after app exit
    cliphist # clipboard history (optional utility)
    xdg-utils # xdg-open, xdg-email, required by KDE for file associations
    wlogout # graphical logout menu (optional)
    gifsicle # GIF optimization
  ];
}
