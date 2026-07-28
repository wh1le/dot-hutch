{ pkgs, lib, ... }:
{
  boot.kernelPatches = [{
    name = "hibernate-lz4";
    patch = null;
    structuredExtraConfig = {
      HIBERNATION_COMP_LZ4 = lib.kernel.yes;
      CRYPTO_LZ4 = lib.kernel.yes;
    };
  }];

  boot.kernelParams = [
    "hibernate.compressor=lz4"
    # 0x200 = disable PSR/Panel Replay — Radeon 780M (Phoenix) flicker fix
    "amdgpu.dcdebugmask=0x200"
  ];

  systemd.tmpfiles.rules = [ "w /sys/power/image_size - - - - 0" ];

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "10m";
    HibernateMode = "platform";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HoldoffTimeoutSec = 0;
    IdleAction = "ignore";
  };

  systemd.services.ath11k-suspend = {
    description = "Unload ath11k_pci before sleep";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/rmmod ath11k_pci";
    };
  };

  systemd.services.ath11k-resume = {
    description = "Reload ath11k_pci after resume";
    after = [ "suspend.target" "hibernate.target" "suspend-then-hibernate.target" "hybrid-sleep.target" ];
    wantedBy = [ "suspend.target" "hibernate.target" "suspend-then-hibernate.target" "hybrid-sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe ath11k_pci";
    };
  };
}
