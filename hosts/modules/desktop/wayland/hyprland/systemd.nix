{ config, pkgs, ... }:
{
  systemd.user.services = {
    waybar = {
      enable = true;
      description = "Waybar";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${config.users.users.wh1le.home}/.config/waybar/live-reload";
        Restart = "on-failure";
      };
    };

    swww-daemon = {
      enable = true;
      description = "swww daemon";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
      };
    };

    kanshi = {
      enable = true;
      description = "kanshi";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.kanshi}/bin/kanshi reload";
        Restart = "on-failure";
      };
    };

    hypridle = {
      enable = true;
      description = "hypridle";
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.hypridle}/bin/hypridle";
        Restart = "on-failure";
      };
    };

    tmux-spawn-local-session = {
      enable = true;
      description = "tmux nix session";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${config.users.users.wh1le.home}/.config/scripts/tmux-spawn-local-session";
      };
    };

    tmux-spawn-nix-session = {
      enable = true;
      description = "tmux local session";

      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${config.users.users.wh1le.home}/.config/scripts/tmux-spawn-nix-session";
      };
    };
  };
}
