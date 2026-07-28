# ~/.zprofile
# old values for scale
# export QT_AUTO_SCREEN_SCALE_FACTOR=0     # wayland: ignore Xft.dpi
# export QT_QPA_PLATFORMTHEME="hyprqt"
#
# case "$(hostname)" in
#   thinkpad)
#     export GDK_SCALE=1
#     export QT_SCALE_FACTOR=1.2
#     export ELM_SCALE=1.2
#     export XCURSOR_SIZE=30
#     ;;
#   homepc)
#     export GDK_SCALE=1.2
#     export QT_SCALE_FACTOR=1.2
#     export ELM_SCALE=1.2
#     export XCURSOR_SIZE=40
#     export XWAYLAND_SCALE=2
#     export WLR_NO_HARDWARE_CURSORS=1
#     export WLR_DRM_NO_ATOMIC=1
#     ;;
# esac

{ lib, inputs, pkgs, config, ... }:
let
  sessions = config.services.displayManager.sessionData.desktops;
in
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_RENDERER = "vulkan";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${sessions}/share/wayland-sessions --xsessions ${sessions}/share/xsessions";
        user = "greeter";
      };
    } // (if config.networking.hostName == "thinkpad" then {
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = config.my.username;
      };
    } else { });
  };

  services.flatpak.overrides = {
    global = {
      Context = {
        sockets = [ "wayland" "!x11" "!fallback-x11" ];
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # hide startup noise from TTY — goes to journalctl instead
    TTYVTDisallocate = true;
  };

  system.userActivationScripts.linkSystemIcons.text = ''
    mkdir -p "$HOME/.local/share/icons"
    for icon in /run/current-system/sw/share/icons/*; do
      name=$(basename "$icon")
      ln -sfn "$icon" "$HOME/.local/share/icons/$name"
    done
  '';

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        icon-theme = "Tela-circle-dark";
        text-scaling-factor = if config.networking.hostName == "thinkpad" then 0.9 else 1.2;
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
      settings."org/gnome/desktop/sound" = {
        event-sounds = true;
        theme-name = "ocean";
        input-feedback-sounds = true;
      };
    }
  ];

  xdg = {
    portal.enable = true;
    portal.xdgOpenUsePortal = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    sounds.enable = true; # TODO: troubleshoot pipewire issue
    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "kitty.desktop"
        ];
      };
    };
    portal.extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
  };

  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1"; # wayland fix

  sops.secrets.openweathermap = {
    owner = config.my.username;
    group = "users";
    mode = "0400";
  };

  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  programs.dconf.enable = true;

  xdg.portal.config.common.default = [ "gtk" ];
  xdg.portal.config.hyprland = lib.mkForce {
    default = [ "gtk" ];
    "org.freedesktop.impl.portal.Screenshot" = [ "hyprland" ];
    "org.freedesktop.impl.portal.ScreenCast" = [ "hyprland" ];
    "org.freedesktop.impl.portal.GlobalShortcuts" = [ "hyprland" ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
    "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    "org.freedesktop.impl.portal.AppChooser" = [ "gtk" ];
    "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
    "org.freedesktop.impl.portal.Inhibit" = [ "gtk" ];
    "org.freedesktop.impl.portal.Access" = [ "gtk" ];
    "org.freedesktop.impl.portal.Account" = [ "gtk" ];
    "org.freedesktop.impl.portal.Email" = [ "gtk" ];
    "org.freedesktop.impl.portal.Print" = [ "gtk" ];
    "org.freedesktop.impl.portal.Background" = [ "gtk" ];
  };

  qt.enable = true;

  services.playerctld.enable = true;
  services.hypridle.enable = false;

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = lib.mkForce "/run/current-system/sw/bin/start-hyprland";
    };
  };

  programs = {
    hyprland.enable = true;
    hyprland.withUWSM = true;
    hyprland.package = pkgs.hyprland;
    hyprland.portalPackage = pkgs.xdg-desktop-portal-hyprland;
    hyprland.xwayland.enable = true;
  };

  environment.systemPackages = [
    pkgs.xdg-utils
    # pkgs.xdgmenumaker # breaking
    pkgs.desktop-file-utils
    pkgs.shared-mime-info

    pkgs.libcanberra-gtk3 # audio

    # theme
    pkgs.tela-circle-icon-theme
    pkgs.rose-pine-cursor
    pkgs.rose-pine-hyprcursor

    # clipbaord
    pkgs.wl-clipboard # wlogout # graphical logout menu (optional)
    pkgs.wl-clip-persist # keeps clipboard after app exit

    pkgs.glib
    pkgs.gnome-themes-extra
    pkgs.libappindicator-gtk3

    pkgs.qt6.qtwayland

    pkgs.swaynotificationcenter

    pkgs.awww
    pkgs.grim
    pkgs.slurp
    pkgs.wl-screenrec
    pkgs.gifski # video -> gif
    pkgs.wf-recorder
    pkgs.hyprshot # qr scan
    pkgs.qrtool # qr scan

    pkgs.pywal16
    pkgs.pywalfox-native

    pkgs.playerctl
    pkgs.brightnessctl

    pkgs.xclip
    pkgs.cliphist

    pkgs.hypridle
    pkgs.hyprcursor
    pkgs.hyprsunset
    pkgs.hyprpicker

    pkgs.udiskie
    pkgs.kdePackages.ocean-sound-theme

    pkgs.cage
    pkgs.gamescope
    pkgs.wl-clipboard
    pkgs.wl-clip-persist


    pkgs.xrdb

    pkgs.hyprpolkitagent
    pkgs.kanshi

    # zoom
    (pkgs.makeDesktopItem {
      name = "Zoom";
      desktopName = "Zoom";
      genericName = "Meetings";
      comment = "Web Zoom (Chromium) — Wayland screen share works";
      exec = "chromium --ozone-platform=wayland https://app.zoom.us/wc/home %U";
      icon = "chromium"; # zoom-us pixmap removed with the package; swap to a zoom.png path if you want the brand icon
      categories = [
        "Network"
        "VideoConference"
        "InstantMessaging"
      ];
      keywords = [
        "zoom"
        "meeting"
        "video"
        "call"
      ];
      mimeTypes = [
        "x-scheme-handler/zoommtg"
      ];
    })
  ];
}
