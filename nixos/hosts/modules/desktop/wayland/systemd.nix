{ ... }:
{
  # systemd.services.NetworkManager-wait-online.enable = false;

  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
