{ pkgs, ... }:
{
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "ntppool1.time.nl"
      "nts.netnod.se"
      "ptbtime1.ptb.de"
      "time.dfm.dk"
      "time.cifelli.xyz"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 1234 ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1234 ];
    # allowedUDPPorts = [ 51820 ]; # Only needed for a local WireGuard listener using this port.
  };

  environment.systemPackages = [ pkgs.wireguard-tools ];
}
