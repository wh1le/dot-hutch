{ pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.validateSopsFiles = false;
  sops.age.generateKey = false;

  sops.defaultSopsFile = "/home/wh1le/.secrets/sops/nix.yaml";
  sops.age.keyFile = "/home/wh1le/.secrets/sops/age/keys.txt";
  sops.defaultSopsFormat = "yaml";

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
