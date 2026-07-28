{ pkgs, ... }: {

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
  };

  programs = {
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
    dconf.profiles.user.databases = [
      {
        settings."org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          show-image-thumbnails = "always";
        };
        settings."org/gnome/nautilus/list-view" = {
          default-zoom-level = "small";
        };
        settings."org/gnome/nautilus/icon-view" = {
          default-zoom-level = "small-plus";
        };
        settings."org/freedesktop/Tracker3/Miner/Files" = {
          index-removable-devices = true;
          index-on-battery = true;
          index-on-battery-first-index = true;
        };
      }
    ];
  };

  environment.pathsToLink = [ "share/thumbnailers" ];
  environment.systemPackages = [
    pkgs.nautilus
    pkgs.sushi
    pkgs.localsearch

    pkgs.peazip

    pkgs.evince
    pkgs.ffmpegthumbnailer
    pkgs.ffmpeg-headless
    pkgs.libheif
    pkgs.libheif.out
    pkgs.webp-pixbuf-loader
    pkgs.gnome-epub-thumbnailer
  ];
}
