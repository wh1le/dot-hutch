{
  pkgs,
  inputs,
  config,
  ...
}:
{
  environment.variables.SOPS_AGE_KEY_FILE = "/home/wh1le/.secrets/sops/age/keys.txt";
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.generateKey = false;
  sops.age.keyFile = "/home/pihole/.secrets/sops/age/keys.txt";

  sops.secrets.openweathermap.owner = config.users.users.pihole.name;
  sops.secrets.email.owner = config.users.users.pihole.name;

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
