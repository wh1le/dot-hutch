{
  pkgs,
  lib,
  ...
}:
{
  boot.kernelModules = lib.mkAfter [
    "nzxt-kraken3"
  ];
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
      # optional: wait for USB if needed
      # /run/current-system/sw/bin/udevadm settle || true

      liquidctl initialize all

      liquidctl --match kraken set lcd screen orientation 90

      # liquidctl --match kraken set fan  speed 25 25 30 35 35 45 40 65 45 85 50 100
      # liquidctl --match kraken set fan  speed  25 60  30 80  35 95  37 100

      # liquidctl --match kraken set pump speed 25 60 35 70 40 80 45 90 50 100
      # liquidctl --match kraken set pump speed  25 80  30 90  35 100

      liquidctl --match kraken set fan  speed 27 30 28 70  29 90  30 100
      liquidctl --match kraken set pump speed 27 30 28 90  29 100
    '';
    serviceConfig.RemainAfterExit = true;
    restartIfChanged = true;
  };
}
