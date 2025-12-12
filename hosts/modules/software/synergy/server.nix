{ pkgs, ... }: {
  services.synergy.server = {
    enable = true;
    address = "192.168.50.5";
    screenName = "thinkpad";
    configFile = pkgs.writeText "synergy.conf" ''
      section: screens
        thinkpad:
        homepc:
      end
      section: links
        thinkpad:
          right = homepc
        homepc:
          left = thinkpad
      end
    '';
  };

  networking.firewall.allowedTCPPorts = [ 24800 ];
}
