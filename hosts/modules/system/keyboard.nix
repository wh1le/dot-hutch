{
  pkgs,
  ...
}:
{
  # environment.variables = {
  #   XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
  #   XKB_DEFAULT_LAYOUT = "us,ru";
  #   XKB_DEFAULT_OPTIONS = "ctrl:swapcaps,grp:win_space_toggle";
  # };
  services.xserver.xkb = {
    model = "apple";
    layout = "us";
  };

  # services.xserver.xkb = {
  #   model = "applealu_iso"; # important
  #   layout = "us,ru";
  #   variant = "workman,";
  #   options = "ctrl:swapcaps,grp:win_space_toggle";
  # };

  # console.useXkbConfig = true;

  environment.systemPackages = with pkgs; [
    klavaro
    gtypist
  ];
}
