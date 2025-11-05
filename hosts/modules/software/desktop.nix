{
  pkgs,
  ...
}:

{
  environment.variables.OBSIDIAN_USE_WAYLAND = 1;

  environment.systemPackages = with pkgs; [
    kitty
    wezterm
    telegram-desktop
    vlc
    thunderbird
    obsidian
    zoom-us
    blanket
    joplin-desktop
    qalculate-qt
  ];
}
