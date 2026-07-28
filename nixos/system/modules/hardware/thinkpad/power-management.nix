{ pkgs, ... }:

{
  powerManagement.powertop.enable = true;

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      # CPU governors — powersave with amd_pstate=active is the modern way
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy Performance Preference
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # Platform profile
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Disable boost on battery — saves 2-4W during spikes
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Cap battery performance
      CPU_MIN_PERF_ON_BAT = 10;
      CPU_MAX_PERF_ON_BAT = 80;

      # AMD P-State
      AMD_PSTATE_STATUS = "active";

      # WiFi
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # PCIe, audio, USB
      PCIE_ASPM_ON_BAT = "powersupersave";
      SOUND_POWER_SAVE_ON_BAT = 1;
      USB_AUTOSUSPEND = 1;

      # Battery charge thresholds — keep battery healthy
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  environment.systemPackages = with pkgs; [
    powertop
    powerstat
    htop
  ];
}
