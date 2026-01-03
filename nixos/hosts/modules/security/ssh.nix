{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 1234 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 1234 ];

  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    Host *
      AddKeysToAgent yes
  '';
}
