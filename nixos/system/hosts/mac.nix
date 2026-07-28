{
  inputs,
  self,
  system ? "aarch64-darwin",
  extraModules ? [ ],
  extraSpecialArgs ? { },
}:

inputs.nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs self;
  }
  // extraSpecialArgs;

  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager

    (
      { config, pkgs, lib, ... }:
      let
        supported = lib.filter (p: lib.meta.availableOn pkgs.stdenv.hostPlatform p);
        pkgsOf = module: supported (import module { inherit pkgs; }).environment.systemPackages;
      in
      {
        system.stateVersion = 6;
        networking.hostName = "mac";
        my.username = "nmiloserdov";
        nixpkgs.hostPlatform = lib.mkDefault system;

        environment.variables.EDITOR = "nvim";

        environment.systemPackages =
          pkgsOf ../modules/packages/terminal.nix
          ++ pkgsOf ../modules/packages/unix-general.nix
          ++ pkgsOf ../modules/packages/neovim.nix;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
            username = config.my.username;
            publicRepoUrl = config.my.repoUrls.public;
          };
          users.${config.my.username} = import ../../home/users/mac.nix;
        };

        imports = [
          ../../config.nix
          ../modules/hosts/mac.nix
        ];
      }
    )
  ]
  ++ extraModules;
}
