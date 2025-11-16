{ pkgs, lib, ... }:
{
  # xdg.enable = true;
  xdg.icons.enable = true;
  xdg.portal.enable = true;

  xdg.portal.extraPortals = lib.mkForce [
    pkgs.kdePackages.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
    # pkgs.xdg-desktop-portal-gtk
  ];

  environment.systemPackages = [
    pkgs.xdg-utils
    pkgs.xdgmenumaker
  ];

  environment.variables.XDG_CURRENT_DESKTOP = "Hyprland";
  environment.variables.XDG_SESSION_DESKTOP = "Hyprland";
}
