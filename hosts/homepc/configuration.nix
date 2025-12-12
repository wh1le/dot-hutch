{ modulesPath
, pkgs
, unstable
, ...
}:
{
  system.stateVersion = "25.05";

  networking.hostName = "homepc";

  environment.variables.USER_SCRIPTS_PATH = "$HOME/.local/bin/public";

  services.fwupd.enable = true;

  # TODO: remove
  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.google-chrome
    pkgs.nix-search
    pkgs.socat
    unstable.yewtube
    unstable.yt-dlp
    unstable.ytfzf
    pkgs.lshw
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ../modules/hardware/homepc/hardware-configuration.nix
    ../modules/hardware/homepc/videocards/dual_gpu.nix
    ../modules/hardware/homepc/nzxt_kraken.nix
    ../modules/hardware/homepc/boot.nix
    ../modules/hardware/homepc/monitors.nix

    ../modules/hardware/audio.nix
    # ../modules/hardware/dasung_paperlike.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/usb.nix

    ../modules/nix/settings.nix
    ../modules/nix/auto-upgrade.nix
    ../modules/nix/nixpkgs.nix

    ../modules/security/anti_virus.nix
    ../modules/security/firewall.nix
    ../modules/security/geo.nix
    # ../modules/security/network_dnscrypt-proxy2.nix
    ../modules/security/network_pi_hole.nix
    ../modules/security/security.nix
    ../modules/security/vpn.nix
    ../modules/security/sops.nix
    ../modules/security/ssh.nix
    ../modules/security/encryption.nix

    ../modules/software/virtualisation/qemu.nix
    ../modules/software/virtualisation/docker.nix
    ../modules/software/virtualisation/podman.nix

    ../modules/software/databases/sqlite.nix
    ../modules/software/databases/redis.nix
    ../modules/software/databases/postgresql.nix

    ../modules/software/languages/ruby.nix
    ../modules/software/languages/python.nix

    ../modules/software/syncthing/server.nix
    ../modules/software/input_leap.nix

    ../modules/software/desktop.nix
    ../modules/software/devops.nix
    ../modules/software/firefox.nix
    ../modules/software/nvim.nix
    ../modules/software/kde_connect.nix
    ../modules/software/utils.nix
    ../modules/software/flatpaks.nix
    # ../modules/software/llms.nix
    # ../modules/software/n8n.nix
    ../modules/software/steam.nix
    # ../modules/software/searx.nix
    # ../modules/software/reverse_proxy.nix

    ../modules/system/filesystem.nix
    ../modules/system/keyboard.nix
    ../modules/system/languages.nix
    ../modules/system/locales.nix
    ../modules/system/terminal.nix
    ../modules/system/coding.nix
    ../modules/system/users.nix
    ../modules/system/fonts.nix
    ../modules/system/media.nix
    ../modules/system/trash_cleaning.nix

    ../modules/desktop/wayland/hyprland/hyprland.nix
    ../modules/desktop/wayland/hyprland/desktop.nix
    ../modules/desktop/wayland/hyprland/systemd.nix
    ../modules/desktop/wayland/hyprland/icons.nix
    ../modules/desktop/wayland/kde_packages.nix
    ../modules/desktop/wayland/pointer.nix
    ../modules/desktop/wayland/xdg.nix
  ];
}
