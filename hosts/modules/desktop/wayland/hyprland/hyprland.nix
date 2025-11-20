{
  inputs,
  pkgs,
  unstable,
  ...
}:

let
  # [ "default" "hyprland" "hyprland-cross" "hyprland-debug" "hyprland-debug-cross" "hyprland-unwrapped" "hyprtester" "xdg-desktop-portal-hyprland" ]
  hyprland_packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet \                                                                                                                    
          --time --time-format '%I:%M %p | %a • %h | %F' \                                                                                                                   
           --cmd 'uwsm start hyprland'";
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

  # programs.hyprlock = { enable = true; };
  # services.hypridle = { enable = true; };

  environment.systemPackages = [
    pkgs.greetd.tuigreet

    pkgs.waybar # TODO: Switch to unstable
    pkgs.inotify-tools # livereload on waybar config edit

    pkgs.hyprshot # TODO: switch to unstable

    # unstable.hyprlock # screen locker (Hyprland-native)
    # pkgs.hypridle # idle daemon, pairs with hyprlock

    pkgs.hyprcursor # TODO: switch to unstable,
    pkgs.hyprsunset # TODO: switch to unstable night light (temperature control)
    # unstable.hyprpolkitagent

    pkgs.pywal16
    pkgs.pywalfox-native

    unstable.swww # https://github.com/LGFae/swww/issues/398#issuecomment-2907991263
  ];
}
