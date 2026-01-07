{ ... }:
{
  services.thinkfan = {
    enable = true;
    sensors = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/thermal"; indices = [ 0 ]; }
    ];

    fans = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; }
    ];

    levels = [
      [ 1 0 35 ] # Fan off until 35°C
      [ 2 30 45 ] # Level 1: 30-45°C (starts at 35°C)
      [ 3 40 55 ] # Level 2: 40-55°C
      [ 4 50 60 ] # Level 3: 50-60°C
      [ 6 55 65 ] # Level 4: 55-65°C
      [ 7 60 70 ] # Level 5: 60-70°C
      [ 7 65 75 ] # Level 6: 65-75°C
      [ 7 70 32767 ] # Full speed: 70°C+
    ];
  };
}
