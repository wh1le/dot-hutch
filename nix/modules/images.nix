{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    imagemagick
    gimp
  ];
}
