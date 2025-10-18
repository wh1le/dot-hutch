{ ... }:
{

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      max-jobs = "auto";
      cores = 8;
    };
  };
}
