{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    kitty
    wezterm
    telegram-desktop
    vlc
    thunderbird
    obsidian
    zoom-us
    blanket
  ];
}
