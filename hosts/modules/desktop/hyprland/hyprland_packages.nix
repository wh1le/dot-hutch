{
  pkgs,
  unstable,
  lib,
  ...
}:

{
  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";

    HYPRCURSOR_SIZE = 40;
    XCURSOR_SIZE = 40;

    GDK_SCALE = "1.5";
    GDK_BACKEND = "wayland,x11,*";

    # QT_AUTO_SCREEN_SCALE_FACTOR = 1; # you can only pick one QT_AUTO_SCREEN_SCALE_FACTOR or QT_SCALE_FACTOR
    QT_SCALE_FACTOR = 2;

    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";

    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_ENABLE_HIGHDPI_SCALING = 1;

    OBSIDIAN_USE_WAYLAND = 1;
    USER_SCRIPTS_PATH = "$HOME/.config/scripts";
    NIXOS_OZONE_WL = 1;
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  programs.hyprland.enable = true;
  programs.hyprland.package = unstable.hyprland;
  programs.hyprland.xwayland.enable = true;

  xdg.icons.enable = true;
  xdg.portal.enable = true;
  xdg.portal.configPackages = [ unstable.hyprland ];
  xdg.portal.extraPortals = lib.mkForce [
    # unstable.xdg-desktop-portal
    unstable.xdg-desktop-portal-hyprland
    # unstable.kdePackages.xdg-desktop-portal-kde
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.defaultSession = "hyprland";

  services.dbus.enable = true;
  services.dbus.implementation = "broker";

  systemd.services.dunst.enable = true;

  environment.systemPackages = with pkgs; [
    greetd.tuigreet

    wl-clipboard

    fastfetch

    pywal16
    pywalfox-native

    wofi

    swaybg
    swww
    bibata-cursors
    colloid-icon-theme

    waybar
    inotify-tools # livereload on config edit

    dunst
    libnotify

    # pcmanfm

    # image preview
    nsxiv

    grimblast

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

    qt6ct # kde stack scaling
  ];
}
