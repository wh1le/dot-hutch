{
  description = "wh1le NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # private.url = "path:/home/wh1le/dot/nix-private";
    # private.url = "git+ssh://git@github.com/wh1le/dot-nix-private.git";
    # private.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,

      agenix,
      boot,
      # sops-nix,

      home-manager,
      ...
    }@inputs:
    {
      nixConfig.extra-experimental-features = [
        "nix-command"
        "flakes"
      ];

      nixpkgs.config.allowUnfree = true;

      home-manager = {
        users.wh1le = import ./home/wh1le.nix;
        useUserPackages = true;
        backupFileExtension = "backup";
      };

      nixosConfigurations.default = nixpkgs.lib.nixosSystem {

        specialArgs = {
          currentSystem = "x86_64-linux";
          mainUser = "wh1le";
          hostname = "pc";
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          inherit inputs;
        };

        modules = [
          ./hosts/pc.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
