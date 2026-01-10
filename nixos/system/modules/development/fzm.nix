{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.kitty
    pkgs.wezterm
    pkgs.ghosty
  ];
}
