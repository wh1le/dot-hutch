{
  pkgs,
  unstable,
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

  environment.systemPackages = [
    pkgs.psmisc # provides 'killall', 'pstree', general utilities

    pkgs.fzf
    pkgs.btop
    pkgs.tmux
    pkgs.tree
    pkgs.buku # bookmarks

    pkgs.wl-clipboard # wlogout # graphical logout menu (optional)
    pkgs.wl-clip-persist # keeps clipboard after app exit

    pkgs.imgcat

    pkgs.fastfetch
    pkgs.tldr

    pkgs.manix # nix documentation searcher
    unstable.nix-search-tv

    pkgs.mutt # TODO: Mail client
    pkgs.dooit # TODO: todos
    pkgs.astroterm # fun
  ];
}
