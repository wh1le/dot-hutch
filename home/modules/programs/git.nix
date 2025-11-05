{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "Nikita M";
    userEmail = "nmiloserdov@proton.me";

    extraConfig.core.excludesFile = "~/.config/git/ignore";
  };

  # xdg.configFile."git/ignore".text = ''
  #   flake.nix
  #   .envrc
  # '';
}
