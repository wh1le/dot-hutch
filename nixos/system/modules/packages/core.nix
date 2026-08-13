{ pkgs, unstable, ... }:
{
  environment.systemPackages = [
    pkgs.obsidian
    pkgs.mpv
    # unstable.ccusage
  ];
}
