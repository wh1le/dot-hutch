{
  pkgs,
  unstable,
  ...
}:

{
  environment.variables.OBSIDIAN_USE_WAYLAND = 1;

  environment.systemPackages = with pkgs; [
    pkgs.kitty
    unstable.wezterm
    pkgs.telegram-desktop
    pkgs.vlc
    pkgs.thunderbird
    pkgs.obsidian
    pkgs.zoom-us
    pkgs.blanket
    pkgs.joplin-desktop
    pkgs.gnome-calculator
  ];
}
