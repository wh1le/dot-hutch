{ inputs, unstable, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      rmpc = prev.rmpc.overrideAttrs (old: rec {
        version = "unstable-2025-12-17";
        src = prev.fetchFromGitHub {
          owner = "mierak";
          repo = "rmpc";
          rev = "ec9df14ab4dfb5def159a5e16fbe1ac2f5c2c0b4";
          hash = "sha256-CVTHB+11nreizDvfJ5kvA6jEdfgYScvP52Lo7Yentl0=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-d2/4q2s/11HNE18D8d8Y2yWidhT+XsUS4J9ahnxToI0=";
        };
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    pkgs.imagemagick
    pkgs.gifsicle

    # pkgs.gimp

    pkgs.ffmpeg_6-full
    pkgs.ffmpeg
    pkgs.libva-utils

    pkgs.mpd
    pkgs.mpc
    pkgs.blanket
    pkgs.wiremix

    unstable.vlc
    unstable.mpv

    unstable.yewtube
    unstable.yt-dlp
    unstable.ytfzf

    pkgs.rmpc
    unstable.cava
    pkgs.zathura
    pkgs.imv

    inputs.viu-anime.packages.${pkgs.system}.default
  ];
}
