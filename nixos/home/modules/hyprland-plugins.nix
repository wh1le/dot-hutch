{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  hyprspace = inputs.hyprspace.packages.${system}.Hyprspace;
  dark_window = inputs.hypr-darkwindow.packages.${system}.Hypr-DarkWindow;
  hyprbars = inputs.hyprland-plugins.packages.${system}.hyprbars;
in
{

  wayland.windowManager.hyprland.plugins = [
    hyprspace
    dark_window
    hyprbars
  ];

  # https://github.com/hyprland-community/pyprland
  # https://github.com/VirtCode/hypr-dynamic-cursors
  # https://github.com/horriblename/hyprgrass
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars
  # https://github.com/KZDKM/Hyprspace
  # https://github.com/hyprwm/hyprland-plugins
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo

  home.file.".local/share/hypr-plugins/Hypr-DarkWindow.so".source = "${dark_window}/lib/libHypr-DarkWindow.so";
  home.file.".local/share/hypr-plugins/Hyprspace.so".source = "${hyprspace}/lib/libHyprspace.so";
  home.file.".local/share/hypr-plugins/hyprbars.so".source = "${hyprbars}/lib/libhyprbars.so";
}
