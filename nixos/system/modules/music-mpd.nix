{ pkgs, config, lib, ... }:
let
  home = config.users.users.${config.my.username}.home;
  music = "${home}/Music";
in {
  systemd.tmpfiles.rules = [
    "d ${music} 0700 ${config.my.username} users -"
    "d ${music}/mpd 0700 ${config.my.username} users -"
    "d ${music}/mpd/playlists 0700 ${config.my.username} users -"
  ];

  services.mpd = {
    enable = true;
    user = config.my.username;
    dataDir = "${music}/mpd";
    settings = {
      music_directory = music;
      db_file = "${music}/mpd/database";
      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Sound Server";
        }
      ];
    };
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = lib.mkDefault "/run/user/1000";
  };

  environment.systemPackages = [
    pkgs.mpd-mpris
    pkgs.mpd
    pkgs.mpc
  ];
}
