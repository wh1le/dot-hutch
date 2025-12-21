{ modulesPath, pkgs, unstable, ... }:
{
  system.stateVersion = "25.11";
  networking.hostName = "thinkpad";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ./caddy.nix

    ../modules/filesystem.nix
    ../modules/languages.nix
    ../modules/locales.nix
    ../modules/terminal.nix
    ../modules/coding.nix
    ../modules/users.nix
    ../modules/fonts.nix
    ../modules/media.nix
    ../modules/trash.nix

    ../modules/hardware/thinkpad/disable-backlight.nix
    ../modules/hardware/thinkpad/hardware-configuration.nix
    ../modules/hardware/thinkpad/boot-amd.nix
    ../modules/hardware/thinkpad/boot.nix
    ../modules/hardware/thinkpad/network.nix
    ../modules/hardware/thinkpad/keyboard.nix
    # ../modules/hardware/thinkpad/power-management.nix
    ../modules/hardware/thinkpad/power-management-balanced.nix
    ../modules/hardware/thinkpad/cooling.nix
    ../modules/hardware/thinkpad/audio.nix
    ../modules/hardware/printers.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/usb.nix
    # ../modules/hardware/thinkpad/monitors.nix
    # ../modules/hardware/dasung_paperlike.nix

    ../modules/nix/settings.nix
    ../modules/nix/auto-upgrade.nix
    ../modules/nix/nixpkgs.nix

    # ../modules/security/network_dnscrypt-proxy2.nix
    ../modules/security/anti_virus.nix
    ../modules/security/firewall.nix
    ../modules/security/geo.nix
    ../modules/security/security.nix
    ../modules/security/vpn.nix
    ../modules/security/sops.nix
    ../modules/security/ssh.nix
    ../modules/security/encryption.nix

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

    ../modules/software/databases/sqlite.nix
    ../modules/software/databases/redis.nix
    ../modules/software/databases/postgresql.nix

    ../modules/software/virtualisation/qemu.nix
    ../modules/software/virtualisation/docker.nix
    ../modules/software/virtualisation/podman.nix

    ../modules/software/languages/ruby.nix
    ../modules/software/languages/python.nix

    ../modules/software/mpd.nix
    ../modules/software/desktop.nix
    ../modules/software/devops.nix
    ../modules/software/browser.nix
    ../modules/software/nvim.nix
    # ../modules/software/kde_connect.nix
    ../modules/software/utils.nix
    ../modules/software/flatpaks.nix
    ../modules/software/yazi.nix
    # ../modules/software/input_leap.nix
    # ../modules/software/steam.nix
    # ../modules/software/reverse_proxy.nix

    ../modules/software/syncthing/client.nix
    ../modules/software/searx.nix
  ];
}
