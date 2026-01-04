{
  description = "wh1le NixOS Build";

  inputs =
    (import ./nixos/inputs/default.nix)
    // (import ./nixos/inputs/hyprland.nix)
    // (import ./nixos/inputs/utils.nix);

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, hyprland, flatpaks, lanzaboote, disko, ... }@inputs:
    {
      nixConfig = {
        extra-experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      environment.variables.NIX_CONFIG_TYPE = "nix_public";

      nixosConfigurations = {
        system = "x86_64-linux";

        homepc = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/hosts/homepc/configuration.nix
            inputs.sops-nix.nixosModules.sops
            flatpaks.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            { 
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.wh1le = ./nixos/home/users/wh1le.nix;
            }
          ];

          specialArgs = {
            inherit inputs self lanzaboote;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = { allowUnfree = true; };
            };
          };
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          modules = [
            ./nixos/hosts/thinkpad/configuration.nix
            inputs.sops-nix.nixosModules.sops
            flatpaks.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            disko.nixosModules.disko
            { 
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.wh1le = ./nixos/home/users/wh1le.nix;
            }
          ];

          specialArgs = {
            inherit inputs self lanzaboote;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = { allowUnfree = true; };
            };
          };
        };
      };

      homeConfigurations = {
        deck = home-manager.lib.homeManagerConfiguration {
          useUserPackages = true;
          backupFileExtension = "backup";
          modules = [
            ./nixos/home/users/steamdeck.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
  };
}
