{ settings, lib, ... }:
{
  home = {
    username = "${settings.mainUser}";
    homeDirectory = "/home/${settings.mainUser}";
    stateVersion = "25.05";
  };

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";

  imports = lib.after [
    ./modules/system/mime_types.nix
    ./modules/system/icons.nix

    ./modules/programs/git.nix
    ./modules/programs/thunderbird.nix
  ];
}
