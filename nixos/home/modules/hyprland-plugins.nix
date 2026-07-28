{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;

  # dark_window = inputs.hypr-darkwindow.packages.${system}.Hypr-DarkWindow; # disabled: v0.55.2 source breaks vs hyprland 0.55.4 ABI (SPassElementData)
  # hyprfocus = inputs.hyprland-plugins.packages.${system}.hyprfocus;
  # hyprtasking = inputs.hyprtasking.packages.${system}.hyprtasking;
in
{

  wayland.windowManager.hyprland.plugins = [
    # dark_window
    # hyprfocus
    # hyprtasking
  ];

  # Temporarily removed (no v0.54.x support yet):
  # hyprbars — github:hyprwm/hyprland-plugins (latest tag: v0.53.0)
  # Hyprspace — github:KZDKM/Hyprspace (latest: 0.53 compat commit)
  #
  # https://github.com/hyprland-community/pyprland
  # https://github.com/VirtCode/hypr-dynamic-cursors
  # https://github.com/horriblename/hyprgrass
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars
  # https://github.com/KZDKM/Hyprspace
  # https://github.com/hyprwm/hyprland-plugins
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo

  # home.file.".local/share/hypr-plugins/Hypr-DarkWindow.so".source = "${dark_window}/lib/libHypr-DarkWindow.so";
  # home.file.".local/share/hypr-plugins/hyprfocus.so".source = "${hyprfocus}/lib/libhyprfocus.so";
  # home.file.".local/share/hypr-plugins/hyprtasking.so".source = "${hyprtasking}/lib/libhyprtasking.so";
}
