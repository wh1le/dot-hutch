{ settings, ... }:
{
  home = {
    username = "${settings.mainUser}";
    homeDirectory = "/home/${settings.mainUser}";
    stateVersion = "25.05";
  };

  imports = [
    ./modules/git.nix
    # ./modules/setup_dot_files.nix
    ./modules/mime_types.nix
  ];
}
