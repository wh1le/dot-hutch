{ pkgs
, lib
, ...
}:
{
  boot.kernelModules = lib.mkAfter [ "nzxt-kraken3" ];
  environment.systemPackages = lib.mkAfter [ pkgs.liquidctl ];
  services.udev.packages = lib.mkAfter [ pkgs.liquidctl ];
  systemd.services.liquidctl-kraken = {
    description = "Configure NZXT Kraken";

    wantedBy = [ "multi-user.target" ];

    after = [ "uved.service" ];

    serviceConfig.Type = "oneshot";
    serviceConfig.TimeoutStartSec = "5s";
    path = [
      pkgs.liquidctl
      pkgs.coreutils
    ];

    script = ''
      set -euo pipefail
      liquidctl initialize all
      liquidctl --match kraken set lcd screen orientation 90
      liquidctl --match kraken set fan  speed 27 30 28 70  29 90  30 100
      liquidctl --match kraken set pump speed 27 30 28 90  29 100
    '';
    serviceConfig.RemainAfterExit = true;
    restartIfChanged = true;
  };
}
