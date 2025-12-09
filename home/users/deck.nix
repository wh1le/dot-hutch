{
  pkgs,
  ...
}:
{
  description = "Home Manager configuration for Steam Deck";

  programs.home-manager.enable = true;

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "25.11";

    packages = with pkgs; [
      tmux
      neovim
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.bash = {
    enableCompletion = true;
    shellAliases = {
      ns = "home-manager switch";
      ne = "nvim ~/.config/home-manager/home.nix";
    };
  };
}
