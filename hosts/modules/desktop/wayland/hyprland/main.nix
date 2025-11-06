{
  inputs,
  pkgs,
  unstable,
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
  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  # Remove or disable nvidia-vaapi-driver if installed, or keep it and set LIBVA_DRIVER_NAME=disabled for Firefox.
  # Test WLR_RENDERER=vulkan if your Hyprland build supports the Vulkan renderer. If stability worsens, revert. (Follow Hyprland NVIDIA page closely
  programs.uwsm.enable = true;

  environment.variables.HYPRCURSOR_SIZE = 40;
  environment.variables.XCURSOR_SIZE = 40;
  environment.variables.GDK_SCALE = "1.5";
  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  environment.variables.CLUTTER_BACKEND = "wayland";
  environment.variables.XDG_SESSION_TYPE = "wayland";

  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  environment.variables.QT_ENABLE_HIGHDPI_SCALING = 1;
  environment.variables.QT_AUTO_SCREEN_SCALE_FACTOR = 1; # you can only pick one QT_AUTO_SCREEN_SCALE_FACTOR or QT_SCALE_FACTOR
  environment.variables.QT_QPA_PLATFORM = "wayland";

  environment.variables.MOZ_ENABLE_WAYLAND = 1;

  environment.variables.WLR_NO_HARDWARE_CURSORS = 1;

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

  # TODO: consider this to prevent spam from tty
  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal";   # keep errors out of the TTY
  #   TTYReset = true;             # clear previous contents
  #   TTYVHangup = true;
  #   TTYVTDisallocate = true;
  # };

  # programs.hyprlock = {
  #   enable = true;
  # };
  #
  # services.hypridle = {
  #   enable = true;
  # };

  users.groups.dbus-monitor = { };
  users.users.wh1le.extraGroups = [ "dbus-monitor" ];

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

    # unstable.hyprlock # screen locker (Hyprland-native)
    # pkgs.hypridle # idle daemon, pairs with hyprlock

    pkgs.hyprcursor # required for proper cursor theming
    # unstable.hyprpolkitagent
    pkgs.kdePackages.polkit-kde-agent-1
    pkgs.hyprsunset # night light (temperature control)
    pkgs.imv # image viewer

    pkgs.imgcat
    pkgs.lm_sensors
    pkgs.desktop-file-utils

    pkgs.libnotify
    pkgs.dunst

    pkgs.wofi
    pkgs.fuzzel
    pkgs.dmenu-wayland

    # pkgs.grimblast

    pkgs.pywal16
    pkgs.pywalfox-native

    # https://github.com/LGFae/swww/issues/398#issuecomment-2907991263
    unstable.swww
  ];
}
