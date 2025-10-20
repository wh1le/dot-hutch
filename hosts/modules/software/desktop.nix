{
  pkgs,
  ...
}:

{
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "kitty";
  };

  environment.systemPackages = with pkgs; [
    kitty
    telegram-desktop
    vlc
    thunderbird
    obsidian
    zoom-us
    blanket
  ];
}
