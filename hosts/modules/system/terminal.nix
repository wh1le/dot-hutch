{
  pkgs,
  inputs,
  ...
}:
{
  programs.zsh.enable = true;

  users.users.wh1le.shell = pkgs.zsh;

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

    wl-clipboard # wlogout # graphical logout menu (optional)
    wl-clip-persist # keeps clipboard after app exit

    imgcat

    fastfetch

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

    psmisc # provides 'killall', 'pstree', general utilities

    nmap
  ];
}
