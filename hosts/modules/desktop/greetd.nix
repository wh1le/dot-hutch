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

  # ensures the screen is cleared before tuigreet starts
  systemd.services.greetd.serviceConfig = {
    Type = "idle"; # Wait for other services to finish logging
    StandardOutput = "tty";
  };
}
