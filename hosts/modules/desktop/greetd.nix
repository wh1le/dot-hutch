{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --time-format '%I:%M %p | %a • %h | %F' --cmd 'uwsm start hyprland'";
        user = "wh1le";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardOutput = "tty";
  };
}
