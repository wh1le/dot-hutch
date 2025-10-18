{
  pkgs,
  settings,
  ...
}:
{
  programs.zsh.enable = true;

  users.users.${settings.mainUser}.shell = pkgs.zsh;

  environment.variables = {
    EDITOR = "nvim";
    TERM = "kitty";
    TERMINAL = "kitty";
  };

  environment.systemPackages = with pkgs; [
    git
    ncdu

    bash
    zsh

    btop
    htop

    tmux

    # Power features
    fzf
    tree

    # better nix environment management
    direnv
    nix-direnv

    buku # bookmarks

    xh # http

    tldr

    bat

    # nix documentation searcher
    manix
    nix-search-tv

    jq # Json parser
    # http # api

    silver-searcher

    mutt # TODO: Mail client
    dooit # TODO: todos

    lazygit
  ];
}
