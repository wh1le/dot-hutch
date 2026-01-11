{ lib, inputs, pkgs, unstable, config, ... }:

{
  imports = [
    ../wayland/notifications.nix
    ../wayland/uwsm.nix
    ../wayland/desktop.nix
    ../wayland/xdg.nix
    ../wayland/waybar.nix
    ../wayland/icons.nix
    ../wayland/playerctld.nix
    ../wayland/pointer.nix
    ../wayland/qt.nix
    ../wayland/systemd.nix
    ../wayland/theme.nix
    ../wayland/gdk.nix
  ];

  services.greetd.settings.default_session = {
    command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --time-format '%I:%M %p | %a • %h | %F' --cmd 'uwsm start hyprland'";
    user = "wh1le";
  };

  xdg.portal.config = lib.mkForce {
    common = {
      default = [ "gtk" ];
    };
    hyprland = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
      "org.freedesktop.impl.portal.GlobalShortcuts" = [ "hyprland" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
      "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.Inhibit" = [ "gtk" ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.Account" = [ "gtk" ];
      "org.freedesktop.impl.portal.Email" = [ "gtk" ];
      "org.freedesktop.impl.portal.Print" = [ "gtk" ];
      "org.freedesktop.impl.portal.Background" = [ "gtk" ];
    };
  };

  # xdg.portal.config.Hyprland.default = lib.mkForce [
  #   "hyprland"
  #   "kde"
  #   # "gtk"
  # ];

  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };

  programs.hyprland.withUWSM = true;

  environment.variables.XCURSOR_SIZE = if config.networking.hostName == "homepc" then "40" else "30";
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "hyprland:Hyprland";
  };

  # https://wiki.hypr.land/Nix/Cachix/
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs = {
    hyprland.enable = true;
    hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    hyprland.xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };

  environment.sessionVariables = {
    LOCKER = "${pkgs.hyprlock}/bin/hyprlock";
  };

  services.hypridle.enable = false; # we start it manually from hyprland autostart

  environment.systemPackages = [
    pkgs.libappindicator-gtk3

    pkgs.hypridle
    pkgs.hyprlock
    pkgs.hyprshot
    pkgs.hyprcursor
    pkgs.hyprsunset
    # unstable.hyprpolkitagent
  ];
}
