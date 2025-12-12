{ pkgs, ... }: {
  boot.resumeDevice = "/dev/disk/by-uuid/660e220f-ab87-4b0c-ab85-3249468a5487";

  # https://wiki.nixos.org/wiki/Laptop#Power_management
  # services.logind.settings.Login = {
  #   HandleLidSwitch = "suspend";
  #   HandleLidSwitchExternalPower = "lock";
  #   HandleLidSwitchDocked = "ignore";
  # };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchExternalPower = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20m
  '';


  powerManagement.powertop.enable = true;
  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 91;
    };
  };
}
