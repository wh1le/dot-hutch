{ PUBLIC, pkgs, unstable, inputs, ... }: {

  imports = [
    ../modules/desktop/greetd.nix
    ../modules/desktop/compositors/hyprland.nix
  ] ++ [
    ../modules/nix/settings.nix
    ../modules/nix/auto-upgrade.nix
    ../modules/nix/nixpkgs.nix
  ] ++ [
    ../modules/cron.nix
  ] ++ [
    ../modules/development/fzm.nix

    ../modules/software/dolphin.nix
    ../modules/software/pcmanfm.nix
    ../modules/software/archive.nix
    ../modules/software/llms/agents.nix
    ../modules/software/languages/ruby.nix
    ../modules/software/languages/python.nix
  ] ++ [
    ../modules/software/desktop.nix
    ../modules/software/devops.nix
    ../modules/software/browser.nix
    ../modules/software/neovim.nix
    ../modules/software/utils.nix
    ../modules/software/yazi.nix
  ] ++ [
    ../modules/services/caddy.nix
    ../modules/services/searx.nix
    ../modules/services/mpd.nix
    ../modules/services/nextcloud-disroot-encrypted.nix
    ../modules/services/printers.nix
    # ../modules/services/n8n.nix
  ] ++ [
    ../modules/virtualisation/docker.nix
    ../modules/virtualisation/podman.nix
    ../modules/virtualisation/qemu.nix
  ];

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

    chntpw
    hivex
    protonup-qt

    # markdown
    glow
    go-grip
  ];

}
