{
  pkgs,
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

    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_SCALE_FACTOR = 2;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_ENABLE_HIGHDPI_SCALING = 1;

    OBSIDIAN_USE_WAYLAND = 1;
    USER_SCRIPTS_PATH = "$HOME/.config/scripts";
    # NIXOS_OZONE_WL=1;
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  xdg.icons.enable = true;

  # Apply as the default GTK icon theme system-wide
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Colloid
  '';
  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-icon-theme-name=Colloid
  '';

  # Optional: also set for GTK2 apps
  environment.etc."gtk-2.0/gtkrc".text = ''
    gtk-icon-theme-name="Colloid"
  '';

  systemd = {
    services = {
      dunst = {
        enable = true;
      };
    };
  };

  # Wayland specific
  services.sunshine.capSysAdmin = true;

  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
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

    pcmanfm

    # nautilus
    nautilus
    sushi

    # image preview
    nsxiv

    # Screen capture
    hyprshot
    satty
    wf-recorder
  ];
}
