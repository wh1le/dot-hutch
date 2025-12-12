{ ... }: {
  services.syncthing = {
    enable = true;
    user = "wh1le";
    group = "users";
    dataDir = "/home/wh1le/.syncthing";

    settings = {
      devices = {
        "thinkpad" = { id = "VD4AZ5X-CNJNUPW-EIYE7ET-3FBPEA5-IXMRR3T-POX64IF-XR3E5AJ-LSE3UQZ"; };
      };
      folders = {
        "Music" = {
          path = "/home/wh1le/Music";
          devices = [ "thinkpad" ];
          fsWatcherEnabled = true;
        };
        "Stereo" = {
          path = "/home/wh1le/Stereo";
          devices = [ "thinkpad" ];
          fsWatcherEnabled = true;
        };
        "Documents" = {
          path = "/home/wh1le/Documents";
          devices = [ "thinkpad" ];
          fsWatcherEnabled = true;
        };

        options = {
          urAccepted = -1;
        };
      };

      openDefaultPorts = true;
    };

  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
