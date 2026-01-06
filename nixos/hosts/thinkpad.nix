{ inputs, nixpkgs, nixpkgs-unstable, self, extraModules ? [ ], extraSpecialArgs ? { } }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  } // extraSpecialArgs;

  modules = [
    ({ modulesPath, ... }: {
      system.stateVersion = "25.11";
      networking.hostName = "thinkpad";
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        # hardware
        ./modules/hardware/thinkpad/disko.nix
        ./modules/hardware/thinkpad/hardware-configuration.nix
        ./modules/hardware/thinkpad/disable-backlight.nix
        ./modules/hardware/thinkpad/boot-amd.nix
        ./modules/hardware/thinkpad/boot.nix
        ./modules/hardware/thinkpad/network.nix
        ./modules/hardware/thinkpad/keyboard.nix
        ./modules/hardware/thinkpad/power-management-balanced.nix
        ./modules/hardware/thinkpad/cooling.nix
        ./modules/hardware/thinkpad/audio.nix
        ./modules/hardware/printers.nix
        ./modules/hardware/bluetooth.nix
        ./modules/hardware/usb.nix
        # nix settings
        ./modules/nix/settings.nix
        ./modules/nix/auto-upgrade.nix
        ./modules/nix/nixpkgs.nix
        # system
        ./modules/filesystem.nix
        ./modules/languages.nix
        ./modules/locales.nix
        ./modules/terminal.nix
        ./modules/coding.nix
        ./modules/users.nix
        ./modules/fonts.nix
        ./modules/media.nix
        ./modules/trash.nix
        # security
        ./modules/security/anti_virus.nix
        ./modules/security/gpg.nix
        ./modules/security/pass.nix
        ./modules/security/firewall.nix
        ./modules/security/geo.nix
        ./modules/security/security.nix
        ./modules/security/vpn.nix
        ./modules/security/sops.nix
        ./modules/security/ssh.nix
        ./modules/security/encryption.nix
        # Hyprland
        ./modules/desktop/greetd.nix
        ./modules/desktop/wayland/notifications.nix
        ./modules/desktop/wayland/uwsm.nix
        ./modules/desktop/wayland/desktop.nix
        ./modules/desktop/wayland/xdg.nix
        ./modules/desktop/wayland/hyprland.nix
        ./modules/desktop/wayland/waybar.nix
        ./modules/desktop/wayland/dolphin.nix
        ./modules/desktop/wayland/icons.nix
        ./modules/desktop/wayland/playerctld.nix
        ./modules/desktop/wayland/pointer.nix
        ./modules/desktop/wayland/qt.nix
        ./modules/desktop/wayland/systemd.nix
        ./modules/desktop/wayland/theme.nix
        ./modules/desktop/wayland/gdk.nix
        # Common
        ./common/default.nix
        # software (Development)
        ./modules/software/databases/sqlite.nix
        ./modules/software/databases/redis.nix
        ./modules/software/databases/postgresql.nix
        ./modules/software/virtualisation/docker.nix
        ./modules/software/virtualisation/podman.nix
        ./modules/software/languages/ruby.nix
        ./modules/software/languages/python.nix
        # Services
        ./modules/software/virtualisation/qemu.nix
        ./modules/software/syncthing/client.nix
        # Applications
        ./modules/software/mpd.nix
        ./modules/software/desktop.nix
        ./modules/software/devops.nix
        ./modules/software/browser.nix
        ./modules/software/neovim.nix
        ./modules/software/utils.nix
        # ./modules/software/flatpaks.nix
        ./modules/software/yazi.nix
        ./modules/software/caddy.nix
      ];
    })
    inputs.sops-nix.nixosModules.sops
    # inputs.flatpaks.nixosModules.nix-flatpak
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko
  ] ++ extraModules;
}
