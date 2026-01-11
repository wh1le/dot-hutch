{ pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.swaynotificationcenter
    libnotify
  ];
}
