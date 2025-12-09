{ ... }:
{
  home = {
    username = "work";
    homeDirectory = "/home/work";
    stateVersion = "25.11";
  };

  imports = [
    ../modules/link_dotfiles.nix
    ../modules/programs/git.nix
    # ../modules/programs/keepassxc.nix
  ];
}
