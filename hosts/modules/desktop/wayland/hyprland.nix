{
  inputs,
  pkgs,
  unstable,
  lib,
  ...
}:

let
  package_source = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};

  hyprland_package = package_source.default;
  portal_package = package_source.xdg-desktop-portal-hyprland;
in
{
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  environment.variables.HYPRCURSOR_SIZE = 40;
  environment.variables.XCURSOR_SIZE = 40;
  environment.variables.GDK_SCALE = "1.5";
  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  environment.variables.WLR_NO_HARDWARE_CURSORS = 0;
  environment.variables.CLUTTER_BACKEND = "wayland";
  environment.variables.XDG_SESSION_TYPE = "wayland";

  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  environment.variables.QT_ENABLE_HIGHDPI_SCALING = 1;
  environment.variables.QT_AUTO_SCREEN_SCALE_FACTOR = 1; # you can only pick one QT_AUTO_SCREEN_SCALE_FACTOR or QT_SCALE_FACTOR
  environment.variables.QT_QPA_PLATFORM = "wayland";

  environment.variables.MOZ_ENABLE_WAYLAND = 1;

  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };

  programs = {
    hyprland.enable = true;
    hyprland.package = hyprland_package;
    hyprland.portalPackage = portal_package;
    hyprland.xwayland.enable = true;
    hyprland.withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet \                                                                                                                    
          --time --time-format '%I:%M %p | %a • %h | %F' \                                                                                                                   
           --cmd 'uwsm start hyprland'";
        user = "wh1le";
      };
    };
  };

  # services.displayManager = {
  #   ly.defaultSession = "hyprland";
  #   ly.settings = {
  #     animate = true;
  #     animation = "cmatrix";
  #     hide_borders = true;
  #     clock = "%c";
  #     bigclock = true;
  #     # hide_f1_commands = true;
  #   };
  #
  #   sessionPackages = [ hyprland_package ];
  # };

  programs.hyprlock = {
    enable = true;
  };

  services.hypridle = {
    enable = true;
  };

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  environment.systemPackages = [
    pkgs.greetd.tuigreet

    pkgs.waybar

    pkgs.inotify-tools # livereload on waybar config edit

    pkgs.nsxiv # image preview
    pkgs.grimblast # screenshot

    # Screen capture
    pkgs.hyprshot
    pkgs.satty
    pkgs.wf-recorder

    pkgs.hyprlock # screen locker (Hyprland-native)
    pkgs.hypridle # idle daemon, pairs with hyprlock
    pkgs.hyprcursor # required for proper cursor theming
    unstable.hyprpolkitagent
    pkgs.hyprsunset # night light (temperature control)
    pkgs.imv # image viewer

    pkgs.imgcat
    pkgs.lm_sensors
    pkgs.desktop-file-utils

    pkgs.libnotify
    pkgs.dunst
    pkgs.wofi
    # pkgs.grimblast

    pkgs.pywal16
    pkgs.pywalfox-native

    # https://github.com/LGFae/swww/issues/398#issuecomment-2907991263
    unstable.swww
  ];
}
