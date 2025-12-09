{ inputs, pkgs, unstable, ... }:

let
  # [ "default" "hyprland" "hyprland-cross" "hyprland-debug" "hyprland-debug-cross" "hyprland-unwrapped" "hyprtester" "xdg-desktop-portal-hyprland" ]
  hyprland_packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # https://wiki.hypr.land/Nix/Cachix/
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  services.playerctld.enable = true;

  # TODO: https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings."org/gnome/desktop/interface" = {
  #       gtk-theme = "Adwaita";
  #       icon-theme = "Flat-Remix-Red-Dark";
  #       font-name = "Noto Sans Medium 11";
  #       document-font-name = "Noto Sans Medium 11";
  #       monospace-font-name = "Noto Sans Mono Medium 11";
  #     };
  #   }
  # ];

  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd 'uwsm start hyprland'";
        user = "wh1le";
      };
    };
  };

  programs = {
    hyprland.enable = true;
    hyprland.package = hyprland_packages.default;
    hyprland.portalPackage = hyprland_packages.xdg-desktop-portal-hyprland;
    hyprland.xwayland.enable = true;
    hyprland.withUWSM = true;
  };

  # programs.hyprlock.enable = true;
  # programs.hyprlock.package = hyprland_packages.hyprlock;
  # services.hypridle.enable = true;
  # services.hypridle.package = hyprland_packages.hypridle;

  environment.systemPackages = [
    pkgs.tuigreet

    unstable.waybar # TODO: Switch to unstable
    pkgs.inotify-tools # livereload on waybar config edit

    pkgs.hyprshot # TODO: switch to unstable

    # unstable.hyprlock # screen locker (Hyprland-native)
    # pkgs.hypridle # idle daemon, pairs with hyprlock

    pkgs.hyprcursor # TODO: switch to unstable,
    pkgs.hyprsunset # TODO: switch to unstable night light (temperature control)

    # unstable.hyprpolkitagent

    unstable.pywal16
    unstable.pywalfox-native

    unstable.swww
    unstable.playerctl
    unstable.brightnessctl
    pkgs.yad
    pkgs.libappindicator-gtk3
    (pkgs.python3.withPackages (ps: [ ps.pygobject3 ]))
  ];
}
