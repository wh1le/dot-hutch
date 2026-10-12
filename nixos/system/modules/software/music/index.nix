{ pkgs, unstable, ... }:
let
  vcv-rack-wrapper = unstable.callPackage ./vcv-rack.nix { };
in
{
  environment.systemPackages = [
    # https://github.com/surge-synthesizer/surge
    # pkgs.surge-xt

    # Tracker
    pkgs.sunvox

    # Music as a code
    unstable.sonic-pi

    # Synth
    # pkgs.surge

    # Synth as a code
    pkgs.supercollider

    # pkgs.lmms
    # pkgs.vital
    # pkgs.musescore

    # Dirtywave M8
    pkgs.m8c
    pkgs.teensy-loader-cli

    # vcv-rack-wrapper
  ];
}
