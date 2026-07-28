{
  pkgs,
  config,
  lib,
  ...
}:
{
  console.useXkbConfig = true;
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ config.my.username ];

  services.rpcbind.enable = lib.mkForce false;

  services.autorandr.enable = true;

  system.userActivationScripts.linkSystemIcons.text = ''
    mkdir -p "$HOME/.local/share/icons"
    for icon in /run/current-system/sw/share/icons/*; do
      name=$(basename "$icon")
      ln -sfn "$icon" "$HOME/.local/share/icons/$name"
    done
  '';

  systemd.user.services.polkit-gnome = {
    description = "polkit-gnome authentication agent";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
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
  };

  xdg = {
    portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    sounds.enable = true;
    terminal-exec = {
      enable = true;
      settings = {
        default = [
          "kitty.desktop"
        ];
      };
    };
  };

  environment.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";

    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
    XDG_CURRENT_DESKTOP = "i3";
    XDG_SESSION_TYPE = "x11";
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "30";
  };

  environment.variables._JAVA_AWT_WM_NONREPARENTING = "1";

  sops.secrets.openweathermap = {
    owner = config.my.username;
    group = "users";
    mode = "0400";
  };

  systemd.user.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  qt.enable = true;

  services = {
    playerctld.enable = true;

    dbus = {
      enable = true;
      implementation = "broker";
    };

    xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3;
        extraPackages = [
          pkgs.i3blocks
          pkgs.i3lock
          pkgs.feh
        ];
      };
      displayManager.startx.enable = true;
      xkb = {
        layout = "us,ru";
        model = "thinkpad";
      };

      monitorSection = lib.optionalString (config.networking.hostName == "homepc") ''
        HorizSync 30.0 - 160.0
        VertRefresh 50.0 - 75.0
        Modeline "3840x2160" 533.00 3840 3888 3920 4000 2160 2163 2168 2222 +hsync -vsync
      '';
      deviceSection =
        if config.networking.hostName == "homepc" then
          ''
            Option "ConnectedMonitor" "DP-0"
            Option "ModeValidation" "AllowNonEdidModes"
          ''
        else
          ''
            Option "TearFree" "true"
          '';
      screenSection = lib.optionalString (config.networking.hostName == "homepc") ''
        Option "metamodes" "DP-0: 3840x2160 +0+0"
      '';
    };

    getty.autologinUser = config.my.username;
  };

  environment.systemPackages = [
    pkgs.xdg-utils
    pkgs.desktop-file-utils
    pkgs.shared-mime-info

    pkgs.libcanberra-gtk3

    pkgs.tela-circle-icon-theme
    pkgs.rose-pine-cursor

    pkgs.glib
    pkgs.gnome-themes-extra
    pkgs.libappindicator-gtk3

    pkgs.maim
    pkgs.slop
    pkgs.flameshot
    pkgs.simplescreenrecorder
    pkgs.gifski
    pkgs.qrtool

    pkgs.pywal16
    pkgs.pywalfox-native

    pkgs.playerctl
    pkgs.brightnessctl

    pkgs.xclip
    pkgs.clipmenu
    pkgs.copyq

    pkgs.xss-lock
    pkgs.xautolock
    pkgs.redshift
    pkgs.xcolor

    pkgs.polkit_gnome
    pkgs.udiskie
    pkgs.gamescope
    pkgs.dunst
    pkgs.conky

    pkgs.xob
    pkgs.i3-volume
    pkgs.i3-auto-layout
    pkgs.i3-resurrect

    pkgs.picom
    pkgs.fastcompmgr
    pkgs.xrdb
    pkgs.xinit
    pkgs.xrandr
    pkgs.autorandr
    pkgs.arandr
    pkgs.wmctrl
    pkgs.xkb-switch

    pkgs.kdePackages.ocean-sound-theme

    (pkgs.xremap.overrideAttrs (o: {
      pname = "xremap-x11";
      cargoBuildNoDefaultFeatures = true;
      cargoCheckNoDefaultFeatures = true;
      cargoBuildFeatures = [ "x11" ];
      cargoCheckFeatures = [ "x11" ];
      buildInputs = (o.buildInputs or [ ]) ++ [ pkgs.libX11 ];
      nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ pkgs.pkg-config ];
    }))

    (pkgs.makeDesktopItem {
      name = "Zoom";
      desktopName = "Zoom";
      genericName = "Meetings";
      comment = "Web Zoom (Chromium)";
      exec = "chromium https://app.zoom.us/wc/home %U";
      icon = "chromium";
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
