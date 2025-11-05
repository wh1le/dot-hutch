{
  pkgs,
  ...
}:
{
  environment.variables.XCURSOR_THEME = "Bibata-Modern-Ice";
  environment.variables.HYPRCURSOR_THEME = "Bibata-Modern-Ice";

  environment.systemPackages = [
    pkgs.bibata-cursors
  ];
}
