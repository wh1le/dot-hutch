{ inputs, pkgs, ... }: {

   wayland.windowManager.hyprland.plugins = [
     inputs.hyprspace.packages.${pkgs.system}.Hyprspace
     inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
     inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
   ];

  # https://github.com/hyprland-community/pyprland
  # https://github.com/VirtCode/hypr-dynamic-cursors
  # https://github.com/horriblename/hyprgrass
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars
  # https://github.com/KZDKM/Hyprspace
  # https://github.com/hyprwm/hyprland-plugins
  # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo

   home.file.".local/share/hypr-plugins/Hypr-DarkWindow.so".source = "${inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow}/lib/libHypr-DarkWindow.so";
   home.file.".local/share/hypr-plugins/Hyprspace.so".source = "${inputs.hyprspace.packages.${pkgs.system}.Hyprspace}/lib/libHyprspace.so";
   home.file.".local/share/hypr-plugins/hyprbars.so".source = "${inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars}/lib/libhyprbars.so";
}
