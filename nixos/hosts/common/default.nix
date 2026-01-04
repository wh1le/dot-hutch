{ PUBLIC, pkgs, unstable, inputs, ... }: {

  environment.systemPackages = with pkgs; [
    nemo
    below
    nethack
    oxker # docker
    ctop
    gum
    gophertube # https://github.com/krishnassh/gophertube
    # botany
    cbonsai
    # bonsai
    brogue-ce
    tty-solitaire
    tabiew # https://github.com/shshemi/tabiew

    # https://github.com/nadrad/h-m-m
    inputs.h-m-m.packages.${pkgs.stdenv.hostPlatform.system}.default

    moon-buggy

    abook
    mutt # TODO: Mail client

    # mopidy
    # mopidy-soundcloud
    # pyradio
    manga-tui
    # https://github.com/eklairs/tlock
    wego
    # unstable.wifitui
    nemu # qemu
    lnav
    genact

    # app launcher
    j4-dmenu-desktop
  ];

  imports = [
    ../modules/cron.nix

    ../modules/software/searx.nix
    ../modules/software/nextcloud-disroot-encrypted.nix
    ../modules/hardware/printers.nix
    # "../modules/software/caddy.nix"
    # ../modules/software/reverse_proxy.nix
  ];
}
