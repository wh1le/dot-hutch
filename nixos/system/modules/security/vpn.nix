{ pkgs
, ...
}:
{
  security.sudo.extraRules = [
    {
      users = [ "wh1le" ];
      commands = [
        { command = "/run/current-system/sw/bin/openvpn"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  environment.systemPackages = with pkgs; [
    openvpn
  ];
}
