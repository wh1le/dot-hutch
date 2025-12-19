{ config, pkgs, ... }:

{
  powerManagement.powertop.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # CPU Performance scaling
      # Using 'powersave' with amd_pstate=active is actually the modern way
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy Performance Preference (EPP)
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # AMD P-State specific (since you have it active in kernelParams)
      # These values help the driver manage frequencies better
      AMD_PSTATE_STATUS = "active";

      # Reduce wakeups by managing radio and disk
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Aggressive Power Management for PCIe and Audio
      PCIE_ASPM_ON_BAT = "powersave";
      SOUND_POWER_SAVE_ON_BAT = 1;

      # USB Autosuspend - This helps with the 'keyd' and USB wakeups
      USB_AUTOSUSPEND = 1;
    };
  };

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
