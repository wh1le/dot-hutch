{ ... }: {
  users.groups.shared-media = { };

  users.users.wh1le.extraGroups = [ "shared-media" "media" ];

  services.syncthing = {
    enable = true;
    user = "syncthing";
    group = "syncthing";

    extraGroups = [ "media" ];

    settings = {
      folders = {
        "shared-music-playlists" = {
          path = "/srv/syncthing";
          devices = [ ];
        };
      };
    };

    openGUI = true;
    openFirewall = true;
  };
}
