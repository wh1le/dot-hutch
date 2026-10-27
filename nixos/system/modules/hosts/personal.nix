{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  networking.extraHosts = ''
    127.0.0.1 lvh.me app.lvh.me api.lvh.me docs.lvh.me
  '';

  imports = [
    ../../../config.nix
    ../i3.nix
    ../security.nix
    ../nix-settings.nix
    ../cron.nix
    ../virtualisation.nix
  ]
  ++ [
    ../software/flatpak.nix
    ../software/nautilus.nix
    ../software/thunar.nix
    ../software/quickshell.nix
    ../software/elasticsearch.nix
    ../software/redis-tui.nix
    ../software/headlamp.nix
    ../software/music-production.nix
    # ../software/pi-chamber.nix
    ../software/searx.nix
    ../software/music/index.nix
    ../software/difit.nix

    ../packages/terminal.nix
    ../packages/neovim.nix
    ../packages/unix-general.nix
    ../packages/software.nix

    ../linux.nix
    ../../cves/emudra-certificate-compromise.nix
  ]
  ++ [
    ../users.nix
    ../fonts.nix
    ../security.nix
    ../music-mpd.nix
  ];

  environment.systemPackages = [
    pkgs.conky
    pkgs.linuxPackages.turbostat
    pkgs.lshw
    pkgs.zsh-powerlevel10k

    # test documents preview
    pkgs.zathura
    pkgs.mupdf

    pkgs.zenity # file picker

    # harness

    unstable.rtk
    unstable.fff
  ];
}
