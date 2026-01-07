{ pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.swaynotificationcenter
    libnotify
    # pkgs.dunst
  ];

  # services.dbus.packages = [ pkgs.swaynotificationcenter ];
}
