{ pkgs, ... }: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        backend = "iwd";
      };
    };
  };

  hardware.firmware = [ pkgs.linux-firmware ];
}
