{
  config,
  pkgs,
  unstable,
  ...
}:
let
  home = config.users.users.wh1le.home;
in
{
  systemd.user.services = {
    tmux-spawn-local-session = {
      enable = true;
      description = "tmux nix session";
      wantedBy = [ "default.target" ];
      path = [
        pkgs.nix
        unstable.tmux
      ];

      environment = {
        HOME = home;
      };

      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${home}/.config/scripts/tmux-spawn-local-session";
      };
    };

    tmux-spawn-nix-session = {
      enable = true;
      description = "tmux local session";
      environment = {
        HOME = home;
      };

      wantedBy = [ "default.target" ];
      path = [
        pkgs.nix
        pkgs.tmux
      ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash ${home}/.config/scripts/tmux-spawn-nix-session";
      };
    };
  };
}
