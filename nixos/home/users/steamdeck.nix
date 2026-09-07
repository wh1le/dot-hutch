{ pkgs, inputs, ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "deck";
    homeDirectory = "/home/deck";
    stateVersion = "25.11";

    packages = with pkgs; [
      tmux
      neovim
      inputs.m8c.packages.${pkgs.system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  imports = [
    ../modules/link-dot-files.nix
  ];

  programs.bash = {
    enableCompletion = true;
    shellAliases = {
      ns = "home-manager switch";
      ne = "nvim ~/.config/home-manager/home.nix";
    };
  };
}
