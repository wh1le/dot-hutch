{ unstable, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.imagemagick
    pkgs.gimp

    pkgs.ffmpeg_6-full
    pkgs.ffmpeg
    pkgs.libva-utils

    pkgs.mpd
    pkgs.blanket

    unstable.vlc
    unstable.mpv
  ];
}
