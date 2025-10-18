{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # images
    imagemagick
    gimp

    # videos
    ffmpeg
    libva-utils
    vlc
    mpv

    # music
    mpd
    blanket
  ];
}
