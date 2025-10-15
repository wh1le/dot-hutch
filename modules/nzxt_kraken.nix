{
  pkgs,
  lib,
  ...
}:
{
  boot.kernelModules = lib.mkAfter [ "nzxt-kraken2" ];
  environment.systemPackages = lib.mkAfter [ pkgs.liquidctl ];
  services.udev.packages = lib.mkAfter [ pkgs.liquidctl ];

  systemd.services.liquidctl-kraken = {
    description = "Configure NZXT Kraken on boot";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "udev.service"
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.liquidctl}/bin/liquidctl initialize all

      liquidctl set fan  speed 25 35 30 45 35 60 40 80 43 90 45 100
      liquidctl set pump speed 25 70 35 80 40 90 43 100
    '';
    serviceConfig.RemainAfterExit = true;
  };
}
