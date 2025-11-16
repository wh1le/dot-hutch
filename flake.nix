{
  description = "wh1le NixOS Build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      rev = "b10b9660004b3dfaf9e11a305d78f24955b089a4";
      submodules = true;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      sops-nix,
      hyprland,
      flatpaks,
      ...
    }@inputs:
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
            ./hosts/homepc/configuration.nix
            inputs.sops-nix.nixosModules.sops
            flatpaks.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager.users.wh1le = ./home/users/wh1le.nix;
              # username = "wh1le";
              # homeDirectory = "/home/wh1le";
              # stateVersion = "25.05";
            }
          ];

          specialArgs = {
            inherit inputs self;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
            };
          };
        };
      };

      homeConfigurations = {
        deck = home-manager.lib.homeManagerConfiguration {
          useUserPackages = true;
          backupFileExtension = "backup";
          modules = [
            ./home/deck.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
