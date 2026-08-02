{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.nix-search
    pkgs.tokei # total lines of code

    pkgs.zoxide
    pkgs.fzf
    pkgs.fd # search
    pkgs.duckdb
    pkgs.epub-thumbnailer
    pkgs.unar
    pkgs.ouch # archives

    pkgs.rclone
    pkgs.btop
    pkgs.kitty
    pkgs.tmux
    pkgs.tmuxinator
    # crystal + shards: build tmux-fingers from source
    pkgs.crystal
    pkgs.shards
    pkgs.tree
    pkgs.buku # bookmarks
    pkgs.gh
    pkgs.tabiew # https://github.com/shshemi/tabiew

    pkgs.imgcat
    pkgs.poppler-utils # pdftoppm/pdfinfo for yazi pdf preview

    pkgs.fastfetch
    pkgs.tldr

    pkgs.diff-so-fancy
    pkgs.eza

    pkgs.gum

    pkgs.lnav

    pkgs.manix # nix documentation searcher
    pkgs.nix-search-tv

    #pkgs.mutt   # TODO: Mail client
    # pkgs.dooit # TODO: todos
    pkgs.astroterm
    pkgs.socat
    pkgs.mpls
    pkgs.abook
    pkgs.dnsutils
    pkgs.pywal16

    pkgs.fdupes # duplicate detection

    # fun
    pkgs.nethack
    pkgs.cbonsai
    pkgs.stripe-cli

    # git
    pkgs.serie
    pkgs.tig

    # markdown
    pkgs.glow
    pkgs.go-grip

    # Utils
    pkgs.htop

    pkgs.bat
    pkgs.xh # http
    pkgs.jq # Json parser
    # http # api
    pkgs.silver-searcher
    pkgs.bash
    pkgs.git
    pkgs.lazygit
    pkgs.zsh
    pkgs.glab
    pkgs.vivid # check

    pkgs.zsh-powerlevel10k

    pkgs.direnv
    pkgs.nix-direnv

    pkgs.k9s
    pkgs.dooit

    # pkgs.systemctl-tui
    # pkgs.sysz
    # pkgs.lazyjournal
  ];
}
