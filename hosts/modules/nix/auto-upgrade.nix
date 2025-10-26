{  ... }:

{
  system.autoUpgrade = {
    enable = true;
    operation = "switch";
    flake = "/etc/nixos";
    # flags = [
    #   "--update-input"
    #   "nixpkgs"
    #   "--commit-lock-file"
    # ];
    dates = "monthly";
  };
}
