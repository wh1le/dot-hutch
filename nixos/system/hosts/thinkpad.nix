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
    # inputs.flatpaks.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko

    ({ modulesPath, ... }: {
      system.stateVersion = "25.11";
      networking.hostName = "thinkpad";
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        # hardware
        ../modules/hardware/thinkpad/disko.nix
        ../modules/hardware/thinkpad/hardware-configuration.nix
        ../modules/hardware/thinkpad/disable-backlight.nix
        ../modules/hardware/thinkpad/boot-amd.nix
        ../modules/hardware/thinkpad/boot.nix
        ../modules/hardware/thinkpad/network.nix
        ../modules/hardware/thinkpad/keyboard.nix
        ../modules/hardware/thinkpad/power-management-balanced.nix
        ../modules/hardware/thinkpad/cooling.nix
        ../modules/hardware/thinkpad/audio.nix
        ../modules/hardware/bluetooth.nix
        ../modules/hardware/usb.nix
      ] ++ [
        # system
        ../modules/filesystem.nix
        ../modules/languages.nix
        ../modules/locales.nix
        ../modules/terminal.nix
        ../modules/coding.nix
        ../modules/users.nix
        ../modules/fonts.nix
        ../modules/media.nix
        ../modules/trash.nix
      ] ++ [
        # security
        ../modules/security/anti_virus.nix
        ../modules/security/gpg.nix
        ../modules/security/pass.nix
        ../modules/security/firewall.nix
        ../modules/security/geo.nix
        ../modules/security/security.nix
        ../modules/security/vpn.nix
        ../modules/security/sops.nix
        ../modules/security/ssh.nix
        ../modules/security/encryption.nix
        # Hyprland
      ] ++ [
        ../common/personal.nix
      ] ++ [
        # Services
        ../modules/services/syncthing/client.nix
      ];
    })
  ] ++ extraModules;
}
