{ ... }:
{
  # NOTE: temporary disable clean until second video card is connected
  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 30d";
  # };

  # programs.nh = {
  #   enable = true;
  #   clean.enable = false;
  #   clean.extraArgs = "--keep-since 4d --keep 3";
  #   flake = "/etc/nixos";
  # };

  nix.settings = {
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
    warn-dirty = false;
  };
}
