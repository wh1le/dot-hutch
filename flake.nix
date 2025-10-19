{
  description = "wh1le NixOS Build";

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      # dotfiles,
      sops-nix,
      ...
    }@inputs:
    let
      settings = import (./. + "/settings.nix") { inherit pkgs inputs; };
      pkgs = import nixpkgs {
        system = settings.system;
      };
      unstable = import nixpkgs-unstable {
        system = settings.system;
      };
    in
    {
      nixConfig = {
        extra-experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      environment.variables.NIX_CONFIG_TYPE = "nix_public";

      nixosConfigurations = {
        ${settings.hostname} = nixpkgs.lib.nixosSystem {

          modules = [
            ./hosts/${settings.hostname}/configuration.nix
            inputs.sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs settings unstable; };
        };
      };

      homeConfigurations = {

        ${settings.userName} = home-manager.lib.homeManagerConfiguration {
          useUserPackages = true;
          backupFileExtension = "backup";
          pkgs = nixpkgs.legacyPackages.${settings.system};
          modules = [
            ./home/${settings.mainUser}.nix
            inputs.sops-nix.nixosModules.sops
          ];
          extraSpecialArgs = { inherit inputs; };
          # extraSpecialArgs = {
          #   inherit inputs;
          #   inherit settings;
          #   inherit unstable;
          #   inherit dotfiles;
          # };
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # dotfiles.url = "path:/home/wh1le/dot/files";
    # dotfiles.flake = false;
  };
}
