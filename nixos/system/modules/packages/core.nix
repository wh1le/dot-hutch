{ pkgs, unstable, ... }:
{
  environment.systemPackages = [
    pkgs.obsidian
    pkgs.mpv
    pkgs.yt-dlp

    pkgs.coreutils
    pkgs.watch

    # unstable.ccusage
  ];
}
