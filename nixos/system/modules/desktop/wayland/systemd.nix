{ ... }:
{
  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
