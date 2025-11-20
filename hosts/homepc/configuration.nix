{
  modulesPath,
  pkgs,
  unstable,
  ...
}:
{
  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "homepc";

  environment.variables.USER_SCRIPTS_PATH = "$HOME/.config/scripts";

  services.fwupd.enable = true;

  # TODO: remove
  programs.dconf.enable = true;

  environment.systemPackages = [
    pkgs.google-chrome
    pkgs.nix-search
    unstable.yewtube
    unstable.yt-dlp
    unstable.ytfzf
  ];

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    # ../modules/hardware/homepc/nvidia.nix
    # ../modules/hardware/homepc/radeon.nix
    ../modules/hardware/homepc/dual_gpu.nix
    ../modules/hardware/homepc/nzxt_kraken.nix
    ../modules/hardware/homepc/boot.nix

    ../modules/hardware/audio.nix
    # ../modules/hardware/dasung_paperlike.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/usb.nix

    ../modules/nix/settings.nix
    ../modules/nix/auto-upgrade.nix

    ../modules/security/anti_virus.nix
    ../modules/security/firewall.nix
    ../modules/security/geo.nix
    ../modules/security/network.nix
    ../modules/security/security.nix
    ../modules/security/vpn.nix
    ../modules/security/sops.nix
    ../modules/security/ssh.nix
    ../modules/security/encryption.nix

    ../modules/software/virtualisation/qemu.nix
    ../modules/software/virtualisation/docker.nix
    ../modules/software/virtualisation/podman.nix

    ../modules/software/databases.nix

    ../modules/software/desktop.nix
    ../modules/software/devops.nix
    ../modules/software/firefox.nix
    ../modules/software/nvim.nix
    ../modules/software/kde_connect.nix
    ../modules/software/utils.nix
    ../modules/software/flatpaks.nix
    # ../modules/software/llms.nix
    ../modules/software/n8n.nix
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

    ../modules/desktop/wayland/hyprland/hyprland.nix
    ../modules/desktop/wayland/hyprland/desktop.nix
    ../modules/desktop/wayland/hyprland/systemd.nix
    ../modules/desktop/wayland/kde_packages.nix
    ../modules/desktop/wayland/pointer.nix
    ../modules/desktop/wayland/xdg.nix
    ../modules/desktop/wayland/qt6.nix
  ];
}
