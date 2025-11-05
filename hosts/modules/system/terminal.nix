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
    psmisc # provides 'killall', 'pstree', general utilities

    fzf
    btop
    tmux
    tree
    buku # bookmarks

    wl-clipboard # wlogout # graphical logout menu (optional)
    wl-clip-persist # keeps clipboard after app exit

    imgcat

    fastfetch
    tldr

    manix # nix documentation searcher
    nix-search-tv

    mutt # TODO: Mail client
    dooit # TODO: todos
    astroterm # fun
  ];
}
