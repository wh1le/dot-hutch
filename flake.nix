{
  description = "wh1le NixOS Build";

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      hyprland,
      sops-nix,
      ...
    }@inputs:
    let
      # Import settings *just* for the system string first
      system = (import (./. + "/settings.nix") { }).system; # Assumes settings.nix doesn't need args for system

      pkgs = import nixpkgs {
        inherit system;
      };

      unstable = import nixpkgs-unstable {
        inherit system;
      };

      settings = import (./. + "/settings.nix") { inherit pkgs inputs; };

      # settings = import (./. + "/settings.nix") { inherit pkgs inputs; };
      # pkgs = import nixpkgs {
      #   system = settings.system;
      # };
      # unstable = import nixpkgs-unstable {
      #   system = settings.system;
      # };
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
        homepc = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/homepc/configuration.nix
            inputs.sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
          ];
          specialArgs = { inherit inputs settings unstable; };
        };

        khole = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/khole/configuration.nix
            inputs.sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs settings unstable; };
        };
      };

      homeConfigurations = {
        wh1le = home-manager.lib.homeManagerConfiguration {
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

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    # dotfiles.url = "path:/home/wh1le/dot/files";
    # dotfiles.flake = false;
  };

}
