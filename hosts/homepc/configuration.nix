{ modulesPath, ... }:
{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  # NOTE: Consider to remove
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "homepc";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix

    ../modules/hardware/homepc/nvidia.nix
    ../modules/hardware/homepc/nzxt_kraken.nix
    ../modules/hardware/homepc/boot.nix
    ../modules/hardware/homepc/dasung.nix

    ../modules/hardware/audio.nix
    ../modules/hardware/paperlike.nix
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

    ../modules/software/desktop.nix
    ../modules/software/firefox.nix
    ../modules/software/llm.nix
    ../modules/software/nvim.nix
    ../modules/software/kde_connect.nix
    ../modules/software/virtualisation.nix
    ../modules/software/wine.nix
    ../modules/software/utils.nix

    ../modules/system/filesystem.nix
    ../modules/system/keyboard.nix
    ../modules/system/languages.nix
    ../modules/system/locales.nix
    ../modules/system/terminal.nix
    ../modules/system/users.nix
    ../modules/system/fonts.nix
    ../modules/system/media.nix
    # ../modules/system/monitors.nix

    ../modules/desktop/hyprland/hyprland.nix
    ../modules/desktop/hyprland/kde_packages.nix
    ../modules/desktop/hyprland/wayland.nix
    ../modules/desktop/hyprland/icons.nix
  ];
}
