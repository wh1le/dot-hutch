{ pkgs, ... }: {
  # TODO: https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  environment.sessionVariables = {
    XDG_DATA_DIRS = [ "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}" ];
  };

  environment.systemPackages = [
    # pkgs.libsForQt5.qt5ct
    pkgs.kdePackages.qt6ct
    pkgs.nwg-look
    pkgs.tela-circle-icon-theme
    pkgs.kdePackages.breeze
    pkgs.darkman
    pkgs.glib
  ];
}

