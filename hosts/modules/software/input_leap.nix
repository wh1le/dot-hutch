{ pkgs, ... }: {
  # services.vahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   publish = {
  #     enable = true;
  #     addresses = true;
  #     workstation = true;
  #   };
  # };
  # networking.firewall = {
  #   allowedTCPPorts = [ 24800 ];
  #   allowedUDPPorts = [ 24800 ]; # Optional, for discovery
  # };

  environment.systemPackages = [
    # pkgs.input-leap
    # pkgs.rkvm
  ];
}
