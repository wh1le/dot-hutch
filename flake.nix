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
      nixConfig = {
        extra-excludes = [ ".git" ];
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
            ./nix/hosts/home_pc.nix
            {
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };

        # Provide your custom configuration here
        # other =  {}
      };
    };
}
