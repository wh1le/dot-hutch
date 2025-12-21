{ inputs, pkgs, lib, ... }:
{
  home = {
    username = "wh1le";
    homeDirectory = "/home/wh1le";
    stateVersion = "25.11";
  };

  imports = [
    ../modules/link_dotfiles.nix
    ../modules/hyprland-plugins.nix
    ../modules/firefox.nix
    # ../modules/programs/keepassxc.nix
  ];
}
