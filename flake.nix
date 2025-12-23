{
  description = "wh1le NixOS Build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      ref = "refs/tags/v0.52.0";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/v0.52.0";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/v0.52.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    viu-anime.url = "github:viu-media/viu";

    yazi.url = "github:sxyazi/yazi/e7cd66370fbc7786132c675999d026671ac364a6";

    h-m-m = {
      url = "github:nadrad/h-m-m/b8873636844a1c00baaa091a518b89311227f463";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, hyprland, flatpaks, ... }@inputs:
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
              # home-manager.users.work = ./home/users/work.nix;
            }
          ];

          specialArgs = {
            inherit inputs self;
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = { allowUnfree = true; };
            };
          };
        };

        thinkpad = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/thinkpad/configuration.nix
            inputs.sops-nix.nixosModules.sops
            flatpaks.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager.users.wh1le = ./home/users/wh1le.nix;
              # home-manager.users.work = ./home/users/work.nix;
            }
          ];

          specialArgs = {
            inherit inputs self;
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
            ./home/deck.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
