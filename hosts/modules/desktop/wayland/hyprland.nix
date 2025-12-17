{ inputs, pkgs, unstable, config, ... }:

{
  environment.variables.XCURSOR_SIZE = if config.networking.hostName == "homepc" then "40" else "30";
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "hyprland:Hyprland";
  };

  nix.settings = {
    # https://wiki.hypr.land/Nix/Cachix/
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs = {
    hyprland.enable = true;
    hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    hyprland.xwayland.enable = true;
  };

  security.pam.services.hyprlock = { };

  environment.sessionVariables = {
    LOCKER = "${pkgs.hyprlock}/bin/hyprlock";
  };

  environment.systemPackages = [
    pkgs.libappindicator-gtk3

    pkgs.hypridle
    pkgs.hyprshot
    pkgs.hyprcursor
    pkgs.hyprsunset
    # unstable.hyprpolkitagent
  ];
}
