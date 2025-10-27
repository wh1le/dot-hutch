{ inputs, lib, pkgs, ... }:
{
  home = {
    username = "pihole";
    homeDirectory = "/home/pihole";
    stateVersion = "25.05";
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        # style = "";
        size = 10.0;
      };
    };
  };
}
