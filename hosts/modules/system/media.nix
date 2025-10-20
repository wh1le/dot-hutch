{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # images
    imagemagick
    gimp

    # videos
    ffmpeg_6-full
    ffmpeg
    libva-utils
    vlc
    mpv

    # music
    mpd
    blanket
  ];
}
