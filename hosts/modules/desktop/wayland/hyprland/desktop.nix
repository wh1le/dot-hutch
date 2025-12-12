{ pkgs, unstable, ... }:
{
  environment.variables.HYPRCURSOR_SIZE = 40;
  environment.variables.XCURSOR_SIZE = 40;
  environment.variables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  environment.variables.CLUTTER_BACKEND = "wayland";
  environment.variables.XDG_SESSION_TYPE = "wayland";

  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  environment.variables.QT_ENABLE_HIGHDPI_SCALING = 1;
  environment.variables.QT_AUTO_SCREEN_SCALE_FACTOR = 1; # you can only pick one QT_AUTO_SCREEN_SCALE_FACTOR or QT_SCALE_FACTOR
  # environment.variables.QT_QPA_PLATFORM = "wayland";

  environment.variables.WLR_DRM_NO_ATOMIC = 1;
  environment.variables.XWAYLAND_SCALE = 2;
  environment.variables.XDG_MENU_PREFIX = "plasma-";

  environment.variables.MOZ_ENABLE_WAYLAND = 1;

  environment.variables.NIXOS_OZONE_WL = "1"; # Force Electron apps to use Wayland
  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1"; # wayland fix
  environment.variables.GTK_USE_PORTAL = "1"; # wayland fix

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  programs.uwsm.enable = true;

  environment.systemPackages = [
    # pkgs.imv # image viewer

    pkgs.libnotify
    pkgs.dunst

    pkgs.xclip
    unstable.wf-recorder
    unstable.slurp
  ];
}
