{ pkgs, ... }:
{

  environment.variables.CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  # https://wiki.nixos.org/wiki/Laptop#Power_management

  systemd.services.hibernate-lock = {
    description = "Lock screen before hibernate";
    before = [ "systemd-hibernate.service" ];
    wantedBy = [ "systemd-hibernate.service" ];
    serviceConfig = {
      Type = "forking"; # Changed from oneshot
      User = "wh1le";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.hyprlock}/bin/hyprlock & disown'";
    };
  };

  boot.kernelParams = [ "hib=platform" ];

  services.logind.settings.Login.HandleLidSwitchDocked = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "suspend-then-hibernate";
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.HoldoffTimeoutSec = 0;

  services.logind.settings.Login.IdleAction = "ignore";

  # This issue seems to be caused by bug #1184262 . It is not related to the networking as such, but to power management.
  # https://bugs.launchpad.net/ubuntu/+source/systemd-shim/+bug/1184262
  powerManagement.resumeCommands = ''
    ${pkgs.networkmanager}/bin/nmcli nm sleep false
  '';

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
    HibernateMode=platform
    HibernateState=disk
  '';

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      # CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # more tight option
      # CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance"; # Allow spikes

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

      RADEON_POWER_PROFILE_ON_AC = "default";
      RADEON_POWER_PROFILE_ON_BAT = "low";

      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 91;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    powerstat
  ];
}
