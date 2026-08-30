{ lib, ... }:
let
  imageEditing = [
    "org.gnome.Loupe" # resize
    "page.kramo.Sly" # effects
    "com.github.vikdevelop.photopea_app" # photoshop
    "io.github.CyberTimon.RapidRAW"
  ];

  dev = [
    "com.github.marhkb.Pods"
    "io.podman_desktop.PodmanDesktop" # failed to start
    "com.ranfdev.DistroShelf" # approve
    "app.kreya.Kreya"
    "com.github.Murmele.Gittyup"
  ];

  messaging = [
    "org.telegram.desktop"
  ];

  utilities = [
    "eu.betterbird.Betterbird"
    "io.gitlab.adhami3310.Impression"
    "com.github.vikdevelop.timer"
    "io.github.seadve.Kooha"
    "com.gitlab.bitseater.meteo"
    "io.github.diegopvlk.Dosage"
    "io.github.amit9838.mousam"
    "org.gnome.Geary"
    # "ir.imansalmani.IPlan" # didn't launch
  ];

  fun = [
    "io.github.basshift.Recall"
    "io.github.josephmawa.EncodingExplorer"
    "de.hummdudel.Libellus" # dnd
  ];

  flatpakPackages = [
    "io.github.hkdb.Aerion"
    "org.kde.kwave"
    "com.github.tchx84.Flatseal"
    "de.haeckerfelix.Shortwave"
    "io.dbeaver.DBeaverCommunity"
    "org.gitfourchette.gitfourchette"
    "cz.bugsy.roster"
    "io.github.db_mobile.resonance"
    "rocks.shy.VacuumTube"
  ];
in
{
  environment.sessionVariables.XDG_DATA_DIRS = lib.mkAfter [
    "/var/lib/flatpak/exports/share"
    "$HOME/.local/share/flatpak/exports/share"
  ];

  services = {
    flatpak = {
      enable = true;
      update = {
        auto.enable = false;
        onActivation = true;
      };
      uninstallUnmanaged = false;
      remotes = [
        {
          name = "flathub";
          location = "https://flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      overrides = {
        global = {
          Context = {
            filesystems = [
              "xdg-run/bus"
              "/run/dbus/system_bus_socket:ro"
              "/nix/store:ro"
              "~/.local/share/fonts:ro"
              "~/.icons:ro"
              "xdg-config:ro"
            ];
            sockets = [
              "x11"
              "fallback-x11"
            ];
            shared = [
              "ipc"
              "network"
            ];
          };
          Environment = {
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
            XCURSOR_THEME = "BreezeX-RosePine-Linux";
            GTK_THEME = "Adwaita:dark";
            ICON_THEME = "Tela-circle-dark";
            XDG_CURRENT_DESKTOP = "i3";
            XDG_SESSION_TYPE = "x11";
          };
        };
        "eu.betterbird.Betterbird"."Session Bus Policy" = {
          "org.freedesktop.secrets" = "talk";
        };
      };
    };
  };

  services.flatpak.packages =
    map (pkg: pkg) flatpakPackages ++ imageEditing ++ dev ++ messaging ++ utilities ++ fun;
}
