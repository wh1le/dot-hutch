{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  self,
  lib,
  extraModules ? [ ],
  extraSpecialArgs ? { },
}:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs self;
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
  }
  // extraSpecialArgs;

  modules = [
    inputs.flatpaks.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko

    ({ modulesPath, ... }: {
      system.stateVersion = "25.11";
      networking.hostName = "homepc";
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      services.fwupd.enable = true;
      networking.networkmanager.enable = true;

      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")

        ../modules/hardware/homepc/hardware-configuration.nix
        ../modules/hardware/homepc/initrd-ssh-unlock.nix
        ../modules/hardware/homepc/gpu_nvidia.nix
        ../modules/hardware/homepc/nzxt_kraken.nix
        ../modules/hardware/audio.nix
        ../modules/hardware/bluetooth.nix
        ../modules/software/steam.nix
      ]
      ++ [
        ../modules/hosts/personal.nix
      ];
    })
  ]
  ++ extraModules;
}
