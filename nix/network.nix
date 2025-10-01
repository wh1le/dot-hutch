{
  config,
  inputs,
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
    hostName = "wh1le";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
  # services.openvpn.servers = {
  #   brasil = {
  #     config = ''
  #       ${builtins.readFile ./.security/expressvpn_brazil.ovpn}
  #       auth-user-pass ${config.sops.secrets."openvpn/express-auth".path}
  #     '';
  #     updateResolvConf = true;
  #     autoStart = false;
  #   };
  #   brasil_two = {
  #     config = ''
  #       ${builtins.readFile ./.security/expresvpn_brasil_2.ovpn}
  #       auth-user-pass ${config.sops.secrets."openvpn/express-auth".path}
  #     '';
  #     updateResolvConf = true;
  #     autoStart = false;
  #   };
  #   belarus = {
  #     config = ''
  #       ${builtins.readFile ./.security/expressvpn_belarus.ovpn}
  #       auth-user-pass ${config.sops.secrets."openvpn/express-auth".path}
  #     '';
  #     updateResolvConf = true;
  #     autoStart = false;
  #   };
  #   georgia = {
  #     config = ''
  #       ${builtins.readFile ./.security/expressvpn_georgia.ovpn}
  #       auth-user-pass ${config.sops.secrets."openvpn/express-auth".path}
  #     '';
  #     updateResolvConf = true;
  #     autoStart = false;
  #   };
  # };
}
