{ pkgs, ... }: {
  # environment.variables.QT_QPA_PLATFORM = "wayland";
  environment.sessionVariables.QT_QPA_PLATFORM = "wayland";
  environment.variables.QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  environment.variables.QT_ENABLE_HIGHDPI_SCALING = 1;
  environment.variables.QT_AUTO_SCREEN_SCALE_FACTOR = 1;

  qt = {
    enable = true;
    platformTheme = "kde";
    # style = "Breeze";
  };


  environment.systemPackages = [
    pkgs.qt6.qtwayland
  ];
}
