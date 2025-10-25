{ pkgs, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    libnotify
    dunst

    bibata-cursors

    wofi

    grimblast

    # Screenshots
    pywal16
    pywalfox-native

    # https://github.com/LGFae/swww/issues/398#issuecomment-2907991263
    unstable.swww
  ];
}
