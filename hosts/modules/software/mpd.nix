{ pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /home/wh1le/Music 0700 wh1le users -"
    "d /home/wh1le/Music/mpd 0700 wh1le users -"
    "d /home/wh1le/Music/mpd/playlists 0700 wh1le users -"
  ];

  services.mpd = {
    enable = true;
    user = "wh1le";
    musicDirectory = "/home/wh1le/Music";
    dbFile = "/home/wh1le/Music/mpd/database";
    dataDir = "/home/wh1le/Music/mpd";
    extraConfig = ''
      audio_output {
        type    "pipewire"
        name    "PipeWire Sound Server"

      }
    '';
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  environment.systemPackages = [
    # pkgs.mpdris2 
    pkgs.mpd-mpris # playerctl mpd helper
  ];
}
