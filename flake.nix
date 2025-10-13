{
  description = "wh1le NixOS Configuration";

  inputs = {
    # private.url = "git+ssh://git@github.com:wh1le/dot-nix-private.git";
    # private.inputs.nixpkgs.follows = "nixpkgs";
    # sops-nix.url = "github:Mic92/sops-nix";
    # home-manager.url = "github:nix-community/home-manager/release-24.11";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      # private,
      # home-manager,
      ...
    }@inputs:

    {
      nixConfig = {
        extra-excludes = [
          ".git"
        ];

        extra-experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs =
            let
              mainUser = "wh1le";
            in
            {
              inherit
                mainUser
                inputs
                ;
            };
          modules = [
            ./hosts/pc.nix
            # private.nixosModules.pc
            {
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };
      };
    };
}
