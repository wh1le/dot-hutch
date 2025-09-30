{
  description = "wh1le NixOS Configuration";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.hyprland-vm-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nix/hosts/main-pc2.nix
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}
