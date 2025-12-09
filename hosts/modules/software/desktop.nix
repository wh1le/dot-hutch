{ pkgs, unstable, ... }:

{
  environment.variables.OBSIDIAN_USE_WAYLAND = 1;

  environment.systemPackages = with pkgs; [
    unstable.kitty
    unstable.wezterm
    unstable.telegram-desktop
    pkgs.thunderbird
    unstable.obsidian
    unstable.zoom-us
    pkgs.blanket
    pkgs.joplin-desktop
    pkgs.gnome-calculator
    pkgs.nsxiv
    # nwg-look
    glib
    pkgs.conky
    pkgs.htop
  ];
}
