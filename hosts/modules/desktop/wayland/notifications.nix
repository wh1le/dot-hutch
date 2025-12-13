{ pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.swaynotificationcenter
    libnotify
    # pkgs.dunst
  ];

  # Optional: systemd user service (auto-start)
  systemd.user.services.swaync = {
    description = "Sway Notification Center";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
      Restart = "on-failure";
    };
  };

  services.dbus.packages = [ pkgs.swaynotificationcenter ];
}
