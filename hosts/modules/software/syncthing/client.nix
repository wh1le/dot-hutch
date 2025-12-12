{ ... }: {
  services.syncthing = {
    enable = true;
    user = "wh1le";
    group = "users";
    dataDir = "/home/wh1le/.syncthing";

    settings = {
      devices = {
        "homepc" = {
          id = "BT2GQFC-QZNRJXI-7PHIHPD-TFW7LCU-CFZBYNX-JIF7ZRJ-E6JB2WH-6QVIPAI ";
          autoAcceptFolders = true;
        };
      };

      folders = {
        "Music" = {
          path = "/home/wh1le/Music";
          devices = [ "homepc" ];
          fsWatcherEnabled = true;
        };
        "Stereo" = {
          path = "/home/wh1le/Stereo";
          devices = [ "homepc" ];
          fsWatcherEnabled = true;
        };
        "Documents" = {
          path = "/home/wh1le/Documents";
          devices = [ "homepc" ];
          fsWatcherEnabled = true;
        };

      };
      options = {
        maxSendKbps = 0; # Unlimited upload
        maxRecvKbps = 0; # Unlimited download
        urAccepted = -1;
        defaultFolderPath = "~";
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
