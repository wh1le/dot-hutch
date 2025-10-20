{
  hyprland,
  pkgs,
  unstable,
  lib,
  ...
}:

{
  # Cusror theme
  environment.variables.XCURSOR_THEME = "Bibata-Modern-Ice";
  environment.variables.HYPRCURSOR_THEME = "Bibata-Modern-Ice";

  environment.variables.HYPRCURSOR_SIZE = 40;
  environment.variables.XCURSOR_SIZE = 40;
  environment.variables.GDK_SCALE = "1.5";
  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.OBSIDIAN_USE_WAYLAND = 1;
  environment.variables.USER_SCRIPTS_PATH = "$HOME/.config/scripts";
  environment.variables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  environment.variables.XDG_CURRENT_DESKTOP = "Hyprland";
  environment.variables.XDG_SESSION_DESKTOP = "Hyprland";
  environment.variables.WLR_NO_HARDWARE_CURSORS = 0;

  programs.hyprland.enable = true;
  programs.hyprland.package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
  programs.hyprland.portalPackage =
    hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  # programs.hyprland.portalPackage = unstable.xdg-desktop-portal-hyprland;
  programs.hyprland.withUWSM = true;
  programs.hyprland.xwayland.enable = true;

  # programs.hyprlock.enable = true;
  # services.hypridle.enable = true;

  xdg.icons.enable = true;
  xdg.portal.enable = true;
  # xdg.portal.configPackages = [ unstable.hyprland ];
  # xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  # xdg.portal.extraPortals = lib.mkForce [
  #   unstable.xdg-desktop-portal-hyprland
  # ];

  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.defaultSession = "hyprland";

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  # systemd.services.dunst.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    # xwayland

    wl-clipboard # wlogout # graphical logout menu (optional)
    wl-clip-persist # keeps clipboard after app exit

    fastfetch

    pywal16
    pywalfox-native

    wofi

    swaybg
    swww
    bibata-cursors
    colloid-icon-theme

    dunst

    waybar
    inotify-tools # livereload on config edit

    libnotify
    # pcmanfm

    nsxiv # image preview
    grimblast # screenshot

    # Screen capture
    hyprshot
    satty
    wf-recorder

    hyprlock # screen locker (Hyprland-native)
    hypridle # idle daemon, pairs with hyprlock
    hyprcursor # required for proper cursor theming
    hyprpolkitagent # alternative to polkit-kde-agent if you prefer native Hyprland look
    hyprsunset # night light (temperature control)
    imv # image viewer

    grimblast
    imgcat
    lm_sensors
    desktop-file-utils

    nautilus
  ];
}
