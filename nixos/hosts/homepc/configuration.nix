{ inputs, modulesPath, pkgs, unstable, ... }:
{
  system.stateVersion = "25.05";
  networking.hostName = "homepc";

  environment.systemPackages = [
    pkgs.chntpw
    pkgs.hivex
    pkgs.sway-launcher-desktop
    pkgs.protonup-qt
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ../modules/hardware/homepc/hardware-configuration.nix
    ../modules/hardware/homepc/videocards/dual_gpu.nix
    ../modules/hardware/homepc/nzxt_kraken.nix
    ../modules/hardware/homepc/boot.nix
    ../modules/hardware/homepc/monitors.nix
    ../modules/hardware/homepc/audio.nix

    # ../modules/hardware/dasung_paperlike.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/usb.nix

    ../modules/nix/settings.nix
    ../modules/nix/auto-upgrade.nix
    ../modules/nix/nixpkgs.nix

    ../modules/cron.nix

    ../modules/software/syncthing/client.nix
    ../modules/security/anti_virus.nix
    ../modules/security/gpg.nix
    ../modules/security/pass.nix
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
    # ../modules/software/input_leap.nix


    ../modules/software/mpd.nix
    ../modules/software/desktop.nix
    ../modules/software/devops.nix
    ../modules/software/browser.nix
    ../modules/software/nvim.nix
    ../modules/software/utils.nix
    ../modules/software/flatpaks.nix
    ../modules/software/yazi.nix
    # ../modules/software/llms.nix
    # ../modules/software/n8n.nix
    ../modules/software/steam.nix
    # ../modules/software/searx.nix
    # ../modules/software/reverse_proxy.nix

    ../modules/filesystem.nix
    ../modules/keyboard.nix
    ../modules/languages.nix
    ../modules/locales.nix
    ../modules/terminal.nix
    ../modules/coding.nix
    ../modules/users.nix
    ../modules/fonts.nix
    ../modules/media.nix
    ../modules/trash.nix
  ] ++ [
    # Common
    ../common/default.nix
  ] ++ [
    ../modules/desktop/greetd.nix
    ../modules/desktop/wayland/notifications.nix
    ../modules/desktop/wayland/uwsm.nix
    ../modules/desktop/wayland/desktop.nix
    ../modules/desktop/wayland/xdg.nix
    ../modules/desktop/wayland/hyprland.nix
    ../modules/desktop/wayland/waybar.nix
    ../modules/desktop/wayland/dolphin.nix
    ../modules/desktop/wayland/icons.nix
    ../modules/desktop/wayland/playerctld.nix
    ../modules/desktop/wayland/pointer.nix
    ../modules/desktop/wayland/qt.nix
    ../modules/desktop/wayland/systemd.nix
    ../modules/desktop/wayland/theme.nix
    ../modules/desktop/wayland/gdk.nix
  ];
}
