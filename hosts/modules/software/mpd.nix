{ pkgs, ... }: {
  services.mpd = {
    enable = true;
    user = "wh1le";
    musicDirectory = "/home/wh1le/Music";
    dbFile = "/home/wh1le/Music/mpd_database";
    extraConfig = ''
      			playlist_directory  "/home/wh1le/Music/mpd_playlists"
      			state_file          "/home/wh1le/.cache/mpd/state"
      			sticker_file        "/home/wh1le/Music/mpd_sticker.sql"
            audio_output {
              type    "pipewire"
              name    "PipeWire Sound Server"

            }
    '';
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000"; # Run 'id -u' to confirm this is 1000
  };
  #
  # systemd.services.mpd2 = {
  #   description = "Music Player Daemon (Stereo)";
  #   after = [ "network.target" "sound.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   environment = {
  #     XDG_RUNTIME_DIR = "/run/user/1000";
  #   };
  #   serviceConfig = {
  #     User = "wh1le";
  #     ExecStart = "${pkgs.mpd}/bin/mpd --no-daemon /home/wh1le/.config/mpd/stereo.conf";
  #     Type = "notify";
  #     Restart = "on-failure";
  #   };
  # };
}
