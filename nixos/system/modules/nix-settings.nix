{ pkgs, inputs, config, ... }: {
  nixpkgs.config = { allowUnfree = true; nvidia.acceptLicense = true; };

  programs.nix-ld.enable = true;

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];


    settings = {
      auto-optimise-store = true;
      max-jobs = 2;
      cores = 0;
      warn-dirty = false;
      trusted-users = [ "root" config.my.username ];

      experimental-features = [ "nix-command" "flakes" ];

      # keep devShell deps reachable so weekly GC won't evict them
      keep-outputs = true;
      keep-derivations = true;

      # https://wiki.hypr.land/Nix/Cachix/
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://ros.cachix.org"
      ];

      trusted-public-keys = [
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0guNosLxLn6Bc="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "/etc/nixos";
    dates = "monthly";
  };

  environment.systemPackages = [
    pkgs.colmena
  ];
}
