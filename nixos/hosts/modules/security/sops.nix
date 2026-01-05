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

# { pkgs, inputs, lib, config, ... }:
# let
#   secretsBase = "/home/wh1le/.secrets/sops";
#   mainFile = "${secretsBase}/nix.yaml";
#   keyFile = "${secretsBase}/age/keys.txt";
#
#   # Check if we are in "Secret Mode"
#   hasSecrets = builtins.pathExists mainFile && builtins.pathExists keyFile;
#
#   # Workaround: If secrets are missing, return a path that won't crash the evaluator
#   # but also won't break the build. 
#   # We use an empty string or a dummy path for the template path.
#   sopsPath = attr: if hasSecrets then attr.path else "/dev/null";
# in
# {
#   imports = [ inputs.sops-nix.nixosModules.sops ];
#
#   sops = {
#     # We leave sops partially "on" so the options exist, 
#     # but we only give it files if they exist.
#     validateSopsFiles = false;
#     defaultSopsFile = if hasSecrets then mainFile else ./dummy-secrets.yaml; # see note below
#     age.keyFile = keyFile;
#
#     secrets = lib.mkIf hasSecrets {
#       "disroot/nextcloud/user" = { owner = "wh1le"; };
#       # ... other secrets
#     };
#
#     templates = lib.mkIf hasSecrets {
#       "searx-env".content = "KEY=${config.sops.placeholder."searx/key"}";
#     };
#   };
#
#   # --- NO MORE lib.mkIf around your services! ---
#   services.searx = {
#     enable = true;
#     # Using our helper function:
#     environmentFile = sopsPath config.sops.templates.searx-env;
#   };
#
#   environment.systemPackages = with pkgs; [ sops age ];
# }
