{ username, ... }: {
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";
  };

  imports = [
    ../modules/link-dot-files.nix
  ];
}
