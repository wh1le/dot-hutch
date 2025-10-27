{config, self, ...}:
let
  KHOLE_SSH_PORT = 1234;
in
{
  sops.secrets = {
    ssh_key = {
      sopsFile = "${self}/secrets/default.yaml";
      key = "khole/ssh/key";
      owner = "root";
      group = "root";
      mode = "0400";
			neededForUsers = true;
      path = "/etc/ssh/authorized_keys.d/pihole";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ KHOLE_SSH_PORT ];
    authorizedKeysFiles = [
      ".ssh/authorized_keys"
      "/etc/ssh/authorized_keys.d/%u"
    ];

    settings = {
      PasswordAuthentication = false;
      # KbdInteractiveAuthentication = false;
      # PermitRootLogin = lib.mkForce "no";
      # KexAlgorithms = [
      #   # ssh-ed25519
      #   "curve25519-sha256"
      #   "curve25519-sha256@libssh.org"
      # ];
    };
  };

  networking.firewall.allowedTCPPorts = [ KHOLE_SSH_PORT ];

  programs.ssh.startAgent = true;
}
