{ ... }:
{
  home = {
    username = "work";
    homeDirectory = "/home/work";
    stateVersion = "25.11";
  };

  imports = [
    # ../modules/programs/keepassxc.nix
  ];
}
