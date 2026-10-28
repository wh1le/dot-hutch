{ config, ... }:
let
  home = config.users.users.${config.my.username}.home;
in
{
  sops = {
    validateSopsFiles = false;
    age.generateKey = false;
    defaultSopsFile = "/var/lib/sops-nix/secrets/nix.yaml";
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    gnupg.sshKeyPaths = [ ];
    defaultSopsFormat = "yaml";

    secrets = {
      "bluetooth/adapters/homepc/controller_mac".owner = config.my.username;
      "bluetooth/adapters/homepc/second_mac".owner = config.my.username;
      "bluetooth/adapters/thinkpad/controller_mac".owner = config.my.username;
      "bluetooth/devices/sony_headphones".owner = config.my.username;
      "bluetooth/devices/apple_keyboard".owner = config.my.username;

      "personal/name".owner = config.my.username;
      "personal/email".owner = config.my.username;
      "personal/gpg_key".owner = config.my.username;
      "personal/location/lat".owner = config.my.username;
      "personal/location/lng".owner = config.my.username;
    };

    templates."git-secrets" = {
      path = "${home}/.config/git/secrets";
      owner = config.my.username;
      content = ''
        [user]
          name = ${config.sops.placeholder."personal/name"}
          email = ${config.sops.placeholder."personal/email"}
          signingkey = ${config.sops.placeholder."personal/gpg_key"}
      '';
    };
  };

}
