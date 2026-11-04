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
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit self inputs publicRepoUrl;
          };
          modules = [
            ./nixos/home/users/steamdeck.nix
          ];
        };
      };

      darwinConfigurations = {
        mac = import ./nixos/system/hosts/macbook.nix {
          inherit inputs self;
          nixpkgs = inputs.nixpkgs;
          nixpkgs-unstable = inputs.nixpkgs-unstable;
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # NVIDIA 615.78.08; update this revision independently of nixpkgs-unstable.
    nixpkgs-nvidia.url = "github:NixOS/nixpkgs/31ecbaca1bdefa45dffc409f0250bd8039ea0010";
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

    m8c.url = "github:laamaa/m8c";

    # Keep Strata's own nixpkgs: its shell requires CUDA 13.0.
    strata.url = "github:Niko1221/Strata";

    # workmux = {
    #   url = "github:raine/workmux";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # steam-config-nix = {
    #   url = "github:different-name/steam-config-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # agent-sandbox.url = "github:archie-judd/agent-sandbox.nix";
  };
}
