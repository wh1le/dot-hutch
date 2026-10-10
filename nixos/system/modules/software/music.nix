{ pkgs, unstable, ... }: {
  environment.systemPackages = [
    pkgs.surge-xt
    pkgs.sunvox
    unstable.sonic-pi
    # pkgs.surge
    pkgs.supercollider
    pkgs.lmms
    pkgs.vital

    pkgs.musescore

    pkgs.teensy-loader-cli
    pkgs.m8c
    unstable.vcv-rack
  ];
}
