{
  inputs,
  nixpkgs,
  nixpkgs-unstable,
  self,
  system ? "aarch64-darwin",
  extraModules ? [ ],
  extraSpecialArgs ? { },
}:

let
  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;

  specialArgs = {
    inherit inputs self unstable;
  }
  // extraSpecialArgs;

  modules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager

    (
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        supported = lib.filter (p: lib.meta.availableOn pkgs.stdenv.hostPlatform p);
        pkgsOf = module: supported (import module { inherit pkgs unstable; }).environment.systemPackages;
      in
      {
        system.stateVersion = 6;
        networking.hostName = "mac";
        my.username = "nikita.miloserdov";
        nixpkgs.hostPlatform = lib.mkDefault system;
        nixpkgs.config.allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [ "obsidian" ];

        environment.variables.EDITOR = "nvim";

        environment.systemPackages =
          pkgsOf ../modules/packages/terminal.nix
          ++ pkgsOf ../modules/packages/unix-general.nix
          ++ pkgsOf ../modules/packages/core.nix
          ++ pkgsOf ../modules/packages/neovim.nix;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs unstable;
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
