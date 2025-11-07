{ ... }:
{
  home = {
    username = "wh1le";
    homeDirectory = "/home/wh1le";
    stateVersion = "25.05";
  };

  imports = [
    ../modules/link_dotfiles.nix
    # ../modules/system/mime_types.nix
    # ../modules/system/pointer.nix

    ../modules/programs/git.nix
    ../modules/programs/keepassxc.nix

    # ./modules/programs/thunderbird.nix
  ];
}
