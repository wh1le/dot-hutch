{
  pkgs,
  mainUser,
}:
{
  services.zsh.enable = true;
  users.users.${mainUser}.shell = pkgs.zsh;

  environment.variables = {
    EDITOR = "nvim";
    TERM = "kitty";
    TERMINAL = "kitty";
  };

  environment.systemPackages = with pkgs; [
    # Resource monitor
    btop

    # Power features
    fzf
    tree

    # better nix environment management
    direnv
    nix-direnv

    # bookmarks
    buku

    # http
    xh

    # summary
    tldr

    # highlight
    bat

    # nix documentation searcher
    manix
    nix-search-tv

    # Json parser
    jq

    # Silver searcher
    silver-searcher

    # TODO: Mail client
    mutt

    # TODO: todos
    dooit

    # http # api
    # kulala.nvim
    # https://github.com/kawre/leetcode.nvim
    # posting
    # lazygit
    # -- terminal --- #
  ];
}
