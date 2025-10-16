{
  pkgs,
  ...
}:

{
  # imports = [ inputs.sops-nix.nixosModules.sops ];

  # sops.defaultSopsFile = ./.security/vpn-auth.yaml;
  # sops.secrets."openvpn/express-auth" = {
  #   mode = "0400";
  # };

  networking = {
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  services = {
    resolved.enable = true;
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };
}
