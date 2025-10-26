{
  description = "wh1le NixOS Build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      rev = "b10b9660004b3dfaf9e11a305d78f24955b089a4";
      submodules = true;
    };

    # dotfiles.url = "path:/home/wh1le/dot/files";
    # dotfiles.flake = false;
  };

  outputs = { self,nixpkgs, nixpkgs-unstable, home-manager, sops-nix, hyprland, ... }@inputs:
    {
      nixConfig = { extra-experimental-features = [ "nix-command" "flakes" ]; };

      environment.variables.NIX_CONFIG_TYPE = "nix_public";

      nixosConfigurations = {
        system = "x86_64-linux";

        homepc = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/homepc/configuration.nix
            inputs.sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
          specialArgs = {
            inherit inputs;
            unstable = import nixpkgs-unstable { system = "x86_64-linux"; };
          };
        };

        khole = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/khole/configuration.nix
            inputs.sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit self inputs; };
        };
      };

      homeConfigurations = {
        wh1le = home-manager.lib.homeManagerConfiguration {
          useUserPackages = true;
          backupFileExtension = "backup";
          # pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home/wh1le.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
