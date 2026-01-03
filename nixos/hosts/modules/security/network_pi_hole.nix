{ pkgs, ... }:

{
  networking = {
    nameservers = [ "192.168.50.2" ];

    dhcpcd.enable = false;
    dhcpcd.extraConfig = "nohook resolv.conf";

    networkmanager = {
      enable = true;
      dns = "none";
      plugins = [ pkgs.networkmanager-openvpn ];
    };

    # Disable dhcpcd DNS management to prevent overwrites
    # dhcpcd.extraConfig = "nohook resolv.conf";
  };

  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "1h";

  environment.systemPackages = with pkgs; [
    nmap
    dig
  ];
}
