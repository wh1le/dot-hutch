{
  description = "wh1le NixOS Configuration";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.hyprland-vm-desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
        # ./configurations/configuration-backup-non-workable.nix
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}