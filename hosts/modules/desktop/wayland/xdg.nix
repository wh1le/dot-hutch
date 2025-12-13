{ pkgs, inputs, ... }:
{
  xdg.portal.enable = true;
  xdg.icons.enable = true;
  xdg.menus.enable = true;
  xdg.mime.enable = true;
  xdg.sounds.enable = true; # TODO: troubleshoot pipewire issue
  xdg.portal.wlr.enable = true;

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal
    pkgs.kdePackages.xdg-desktop-portal-kde
    pkgs.xdg-desktop-portal-gtk
  ];

  xdg.portal.config = {
    common = {
      default = [ "hyprland" ];
      # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
    hyprland = {
      default = [
        "hyprland"
        "kde"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
      "org.freedesktop.impl.portal.OpenURI" = [ "kde" ];
    };
  };

  xdg.portal.config.Hyprland.default = [
    "hyprland"
    "kde"
    # "gtk"
  ];

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.systemPackages = [
    pkgs.xdg-utils
    pkgs.xdgmenumaker
    pkgs.desktop-file-utils
    pkgs.shared-mime-info # database of common mime types
  ];
}
