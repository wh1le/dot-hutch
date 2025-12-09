{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.lazygit

    pkgs.bash
    pkgs.zsh

    pkgs.direnv
    pkgs.nix-direnv

    pkgs.bat
    pkgs.xh # http

    pkgs.jq # Json parser
    # http # api

    pkgs.silver-searcher
  ];
}
