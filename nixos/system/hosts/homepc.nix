{ inputs, nixpkgs, nixpkgs-unstable, self, extraModules ? [ ], extraSpecialArgs ? { } }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };
  } // extraSpecialArgs;

  modules = [
    inputs.flatpaks.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko

    ({ modulesPath, ... }: {
      system.stateVersion = "25.11";
      networking.hostName = "homepc";

      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")

        # ../modules/hardware/dasung_paperlike.nix
        ../modules/hardware/homepc/hardware-configuration.nix
        ../modules/hardware/homepc/videocards/dual_gpu.nix
        ../modules/hardware/homepc/nzxt_kraken.nix
        ../modules/hardware/homepc/boot.nix
        ../modules/hardware/homepc/monitors.nix
        ../modules/hardware/homepc/audio.nix
        ../modules/hardware/bluetooth.nix
        ../modules/hardware/usb.nix
      ] ++ [
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
        ../modules/nix/settings.nix
        ../modules/nix/auto-upgrade.nix
        ../modules/nix/nixpkgs.nix
      ] ++ [
        # ../modules/security/network_dnscrypt-proxy2.nix
        ../modules/security/anti_virus.nix
        ../modules/security/gpg.nix
        ../modules/security/pass.nix
        ../modules/security/firewall.nix
        ../modules/security/geo.nix
        ../modules/security/network_pi_hole.nix
        ../modules/security/security.nix
        ../modules/security/vpn.nix
        ../modules/security/sops.nix
        ../modules/security/ssh.nix
        ../modules/security/encryption.nix
      ] ++ [
        ../modules/services/syncthing/server.nix
      ] ++ [
        ../modules/software/flatpaks.nix
        ../modules/software/llms.nix
        ../modules/software/steam_dual_gpu.nix
      ] ++ [
        ../common/personal.nix
      ];
    })
  ] ++ extraModules;
}
