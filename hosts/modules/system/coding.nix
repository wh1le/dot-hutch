{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    lazygit

    bash
    zsh

    direnv
    nix-direnv

    bat
    xh # http

    jq # Json parser
    # http # api

    silver-searcher
  ];
}
