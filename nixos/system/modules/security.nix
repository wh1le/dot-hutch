{
  config,
  pkgs,
  inputs,
  ...
}:
let
  home = config.users.users.${config.my.username}.home;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.sessionVariables.PASSWORD_STORE_DIR = "$HOME/.secrets/passwords";

  services.passSecretService.enable = true;

  systemd.user.services."dbus-org.freedesktop.secrets".serviceConfig.ExecStart = [
    ""
    "${config.services.passSecretService.package}/bin/pass_secret_service --path ${home}/.secrets/passwords"
  ];

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

  services = {
    openssh = {
      enable = true;
      ports = [ 1234 ];
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    geoclue2.enable = true;

    clamav.scanner = {
      enable = true;
      interval = "Sat *-*-* 04:00:00";
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    wrappers.git-secrets = {
      source = "${pkgs.git}/bin/git";
      owner = "root";
      group = "secrets";
      setgid = true;
    };
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults:${config.my.username} env_keep += "EDITOR SOPS_AGE_KEY_FILE"
      '';
      extraRules = [
        {
          users = [ config.my.username ];
          commands = [
            {
              command = "/run/current-system/sw/bin/openvpn";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/wg-quick";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };

  programs = {
    ssh = {
      startAgent = true;
      agentTimeout = "1h";
      extraConfig = ''
        Host *
          AddKeysToAgent yes
      '';
    };
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  location.provider = "geoclue2";
  systemd.tmpfiles.rules = [
    "d /mnt 0755 ${config.my.username} users -"

    "d ${home}/.gnupg 0700 ${config.my.username} users -"

    "d ${home}/.secrets 750 root secrets -"
    "d ${home}/.secrets/passwords 700 ${config.my.username} users -"
    "d ${home}/.secrets/files 700 ${config.my.username} users -"
    "z ${home}/.secrets/vpn 750 root secrets -"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1234 ];
    allowedUDPPorts = [ 51820 ];
  };

  environment.systemPackages = with pkgs; [
    gnupg
    gnutar

    sops
    age

    pinentry-gnome3
    pinentry-curses # pinentry

    openssl
    cryptsetup # luks
    git-crypt
    git-remote-gcrypt
    hyprpolkitagent
    polkit_gnome
    wireguard-tools

    (pkgs.pass.withExtensions (exts: [
      exts.pass-import
      exts.pass-update
      exts.pass-otp
    ]))
  ];
}
