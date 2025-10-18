{
  pkgs,
  inputs,
  config,
  settings,
  ...
}:
{
  environment.variables.SOPS_AGE_KEY_FILE = "/home/${settings.mainUser}/.secrets/sops/age/keys.txt";
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.generateKey = false;
  sops.age.keyFile = "/home/${settings.mainUser}/.secrets/sops/age/keys.txt";

  sops.secrets.openweathermap.owner = config.users.users.wh1le.name;
  sops.secrets.email.owner = config.users.users.wh1le.name;

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
