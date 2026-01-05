{ pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.validateSopsFiles = false;
  sops.age.generateKey = false;

  sops.defaultSopsFile = "/var/lib/sops-nix/secrets/nix.yaml";
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.defaultSopsFormat = "yaml";

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
