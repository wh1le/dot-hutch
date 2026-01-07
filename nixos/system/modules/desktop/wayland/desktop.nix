{ pkgs, unstable, ... }:
{
  environment.variables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  environment.variables.CLUTTER_BACKEND = "wayland";
  environment.variables.XDG_SESSION_TYPE = "wayland";

  environment.variables.XWAYLAND_SCALE = 2;
  environment.variables.XDG_MENU_PREFIX = "plasma-";

  environment.variables.MOZ_ENABLE_WAYLAND = 1;

  environment.variables.NIXOS_OZONE_WL = "1"; # Force Electron apps to use Wayland
  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1"; # wayland fix

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  environment.systemPackages = [
    unstable.playerctl
    unstable.brightnessctl

    unstable.pywal16
    unstable.pywalfox-native

    unstable.swww


    pkgs.xclip
    pkgs.cliphist

    unstable.wf-recorder
    unstable.slurp

    # pkgs.imv # image viewer
  ];
}
