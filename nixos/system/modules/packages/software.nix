{ pkgs, unstable, ... }: {
  environment.systemPackages = with pkgs; [
    blanket
    vlc
    gophertube

    # pkgs.nsxiv

    pkgs.mpv
    (pkgs.mpv.override {
      scripts = [ mpvScripts.mpris ];
    })

    pkgs.librewolf

    pkgs.rmpc
    pkgs.cava
    pkgs.imv
    pkgs.gophertube

    pkgs.firefox
    pkgs.file-roller

    pkgs.xhost
    pkgs.moonlight-qt

    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-clocks

    pkgs.snapshot # webcamera

    pkgs.foliate

    pkgs.gradia

    pkgs.cheese

    # pkgs.newsboat
    # pkgs.rdrview
    # pkgs.w3m

    # pkgs.onlyoffice-desktopeditors
    pkgs.obsidian

    # yazi
    (pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;
    })

    pkgs.p7zip
    pkgs.resvg
    pkgs.exiftool
    pkgs.mediainfo

    unstable.ghostty
    pkgs.kitty
    pkgs.xterm

  ];
}
