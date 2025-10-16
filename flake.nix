{
  description = "wh1le NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # private.url = "path:/home/wh1le/dot/nix-private";
    # private.url = "git+ssh://git@github.com/wh1le/dot-nix-private.git";
    # private.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      home-manager,
      ...
    }@inputs:

    {
      nixConfig.extra-experimental-features = [
        "nix-command"
        "flakes"
      ];

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs =
          let
            mainUser = "wh1le";
            hostname = "pc";
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          in
          {
            inherit
              mainUser
              unstable
              hostname
              inputs
              ;
          };
        modules = [
          ./hosts/pc.nix
          sops-nix.nixosModules.sops
          # private.nixosModules.pc
          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
}
