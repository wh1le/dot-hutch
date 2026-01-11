{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.kitty
    pkgs.wezterm
    pkgs.ghostty
    pkgs.alacritty
    pkgs.foot
    pkgs.xterm
  ];
}
