{ settings, ... }:

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
    dates = settings.autoUpdateFrequency;
    # channel = "https://nixos.org/channels/nixos-unstable";
  };
}
