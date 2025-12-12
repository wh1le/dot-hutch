{ pkgs
, lib
, ...
}:
{
  services.thinkfan = {
    enable = true;
    sensors = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/thermal"; }
    ];
    fans = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; }
    ];
    levels = [
      [ 0 0 55 ]
      [ 1 48 60 ]
      [ 2 50 61 ]
      [ 3 52 63 ]
      [ 4 56 65 ]
      [ 5 59 66 ]
      [ 7 63 32767 ]
    ];
  };
}
