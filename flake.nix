{
  description = "NixOS Build";
  outputs =
    { self, ... }@inputs:
    let
      username = "wh1le";
      publicRepoUrl = "https://github.com/wh1le/dot-hutch.git";
    in
    {
      nixosConfigurations = {
        homepc = import ./nixos/system/hosts/homepc.nix {
          inherit inputs self;
          inherit (inputs) nixpkgs nixpkgs-unstable;
          inherit (inputs.nixpkgs) lib;

          extraModules = [
            {
              home-manager.extraSpecialArgs = { inherit inputs username publicRepoUrl; };
              home-manager.users.${username} = ./nixos/home/users/main.nix;
            }
          ];
        };

        thinkpad = import ./nixos/system/hosts/thinkpad.nix {
          inherit inputs self;
          inherit (inputs) nixpkgs nixpkgs-unstable;

          extraModules = [
            {
              home-manager.extraSpecialArgs = {
                inherit
                  self
                  inputs
                  username
                  publicRepoUrl
                  ;
              };
              home-manager.users.${username} = ./nixos/home/users/main.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };

      homeConfigurations = {
        deck = inputs.home-manager.lib.homeManagerConfiguration {
          useUserPackages = true;
          backupFileExtension = "backup";
          modules = [
            ./nixos/home/users/steamdeck.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations = {
        mac = import ./nixos/system/hosts/mac.nix {
          inherit inputs self;
        };

        mac-intel = import ./nixos/system/hosts/mac.nix {
          inherit inputs self;
          system = "x86_64-darwin";
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-emoji.url = "github:oxcl/nix-flake-apple-emoji";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # steam-config-nix = {
    #   url = "github:different-name/steam-config-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
}
