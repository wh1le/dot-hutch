{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.input-leap
    # pkgs.rkvm
  ];

  networking.firewall = {
    allowedTCPPorts = [ 24800 ];
    allowedUDPPorts = [ 24800 ]; # Optional, for discovery
  };

}
