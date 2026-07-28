{ pkgs, ... }:
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
    ../software/quickshell.nix
    ../software/elasticsearch.nix
    ../software/redis-tui.nix

    ../packages/terminal.nix
    ../packages/neovim.nix
    ../packages/unix-general.nix
    ../packages/software.nix

    ../linux.nix
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

    # test documents preview
    pkgs.zathura
    pkgs.mupdf

    pkgs.zenity # file picker
  ];
}
