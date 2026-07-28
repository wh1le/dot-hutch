{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  self,
  extraModules ? [ ],
  extraSpecialArgs ? { },
}:

nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs self;
    unstable = import nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  }
  // extraSpecialArgs;

  modules = [
    inputs.flatpaks.nixosModules.nix-flatpak
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.disko.nixosModules.disko

    ({ modulesPath, lib, ... }: {
      system.stateVersion = "25.11";
      networking.hostName = "thinkpad";
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        ../modules/hardware/thinkpad/hardware-configuration.nix
        ../modules/hardware/thinkpad/disable-backlight.nix
        ../modules/hardware/thinkpad/boot-amd.nix
        ../modules/hardware/thinkpad/boot.nix
        ../modules/hardware/thinkpad/power-management.nix
        ../modules/hardware/thinkpad/hibernation.nix
        ../modules/hardware/audio.nix
        ../modules/hardware/bluetooth.nix
      ]
      ++ [
        ../modules/hosts/personal.nix
      ];
    })
  ]
  ++ extraModules;
}
