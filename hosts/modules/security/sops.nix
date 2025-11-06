{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../../secrets/default.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.generateKey = false;
  sops.age.keyFile = "/home/wh1le/.secrets/sops/age/keys.txt";

  sops.secrets.openweathermap = {
    owner = config.users.users.wh1le.name;
    group = "users";
    mode = "0400";
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
