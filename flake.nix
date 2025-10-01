{
  description = "wh1le NixOS Configuration";
  inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # home-manager.url = "github:nix-community/home-manager/release-24.11";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nix/hosts/pc_nvidia.nix
            {
              nixpkgs.config.allowUnfree = true;
            }
            # home-manager.nixosModules.home-manager
            # {
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.wh1le = {
            #     home.stateVersion = "25.05";
            #     # Use env variables to detect NIXOS?
            #     # home.sessionVariables.NVIM_USE_MASON = "1";
            #   };
            # }
          ];
        };
      };
    };
}
