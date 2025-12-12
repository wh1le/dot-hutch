{ ... }: {
  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "syncthing";

    settings = {
      folders = {
        "shared-music-playlists" = {
          path = "/srv/syncthing";
          devices = [ ];
        };
      };
      # devices = {
      # "device1" = { id = "DEVICE-ID-GOES-HERE"; };
      # };
      folders = {
        "Music" = {
          path = "/home/wh1le/Music";
          # devices = [ "device1" "device2" ];
        };
        "Documents" = {
          path = "/home/wh1le/Documents";
          # devices = [ "device1" "device2" ];
        };
        # "Example" = {
        #   path = "/home/myusername/Example";
        #   devices = [ "device1" ];
        #   ignorePerms = false; # Enable file permission syncing
        # };
      };

      openDefaultPorts = true;
    };

  };

  networking.firewall.allowedTCPPorts = [ 8384 ];
}
