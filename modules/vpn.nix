{
  pkgs,
  ...
}:
{
  services.expressvpn.enable = true;

  environment.systemPackages = with pkgs; [
    openvpn
  ];
}
