{ ... }: {
  services.mpd = {
    enable = true;
    user = "wh1le";
    musicDirectory = "/home/wh1le/Music";
    dbFile = "/home/wh1le/Music/mpd_database";
    extraConfig = ''
      audio_output {
        type    "pipewire"
        name    "PipeWire Sound Server"
      }
    '';
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000"; # Run 'id -u' to confirm this is 1000
  };
}
