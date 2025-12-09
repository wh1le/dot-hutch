{ ... }:
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings = {
    auto-optimise-store = true;
    max-jobs = 2;
    cores = 8;
    warn-dirty = false;

    substituters = [ "https://cache.nixos.org" ];
  };
}
