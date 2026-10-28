{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./apparmor.nix
    ./kernel.nix
    ./memory.nix
    ./network.nix
    ./sops.nix
    ./passwords.nix
  ];

  services = {
    geoclue2.enable = true;

    clamav.scanner = {
      enable = true;
      interval = "Sat *-*-* 04:00:00";
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    # NOTE: Attack vector: This gives Git the effective secrets group. (hooks)
    # wrappers.git-secrets = {
    #   source = "${pkgs.git}/bin/git";
    #   owner = "root";
    #   group = "secrets";
    #   setgid = true;
    # };
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraConfig = ''
        Defaults:${config.my.username} env_keep += "EDITOR SOPS_AGE_KEY_FILE"
      '';
      # NOTE: Attack vector: A user who can supply their own configuration can execute commands
      # extraRules = [
      #   {
      #     users = [ config.my.username ];
      #     commands = [
      #       {
      #         command = "/run/current-system/sw/bin/openvpn";
      #         options = [ "NOPASSWD" ];
      #       }
      #       {
      #         command = "/run/current-system/sw/bin/wg-quick";
      #         options = [ "NOPASSWD" ];
      #       }
      #     ];
      #   }
      # ];
    };
  };

  location.provider = "geoclue2";

  systemd.tmpfiles.rules = [
    "d /mnt 0755 ${config.my.username} users -"
  ];

  environment.systemPackages = with pkgs; [
    gnutar

    sops
    age

    openssl
    cryptsetup # luks
    git-crypt
    git-remote-gcrypt
    hyprpolkitagent
    polkit_gnome
  ];
}
