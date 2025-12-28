{ pkgs, unstable, ... }:
{
  programs.zsh.enable = true;

  users.users.wh1le.shell = pkgs.zsh;

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  environment.systemPackages = [

    unstable.sway-launcher-desktop

    pkgs.nix-search

    pkgs.psmisc # provides 'killall', 'pstree', general utilities
    pkgs.lm_sensors
    pkgs.fzf
    pkgs.btop
    unstable.tmux
    pkgs.tree
    pkgs.buku # bookmarks

    pkgs.wl-clipboard # wlogout # graphical logout menu (optional)
    pkgs.wl-clip-persist # keeps clipboard after app exit

    pkgs.imgcat

    pkgs.fastfetch
    pkgs.tldr

    unstable.yazi
    unstable.diff-so-fancy
    unstable.eza
    unstable.nvimpager

    pkgs.manix # nix documentation searcher
    unstable.nix-search-tv

    pkgs.mutt # TODO: Mail client
    # pkgs.dooit # TODO: todos
    pkgs.astroterm
    pkgs.socat
    pkgs.sysz
  ];
}
