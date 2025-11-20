{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.egl-wayland
    pkgs.qt6.full
    pkgs.qt6.qtwayland
    pkgs.kdePackages.qt6gtk2
  ];
}
