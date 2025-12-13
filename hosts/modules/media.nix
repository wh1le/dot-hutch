{ unstable, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.imagemagick
    pkgs.gifsicle

    # pkgs.gimp

    pkgs.ffmpeg_6-full
    pkgs.ffmpeg
    pkgs.libva-utils

    pkgs.mpd
    pkgs.blanket

    unstable.vlc
    unstable.mpv

    unstable.yewtube
    unstable.yt-dlp
    unstable.ytfzf
  ];
}
