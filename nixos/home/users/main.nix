{ username, ... }: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = "Tela-circle-dark";
  };

  programs.browserpass.enable = true;
  # programs.browserpass.browsers = [ "firefox" "librewolf" ];

  # programs.steam.config = lib.mkIf (osConfig.networking.hostName == "homepc") {
  #   enable = true;
  #   apps."438100".launchOptionsStr =
  #     ''WINEDLLOVERRIDES="iyuv_32=" __GL_SYNC_TO_VBLANK=0 WINE_GST_DECODER_PLUGIN_RANK="vaapih264dec:MAX" gamemoderun %command%   --enable-hw-video-decoding'';
  # };

  imports = [
    ../modules/link-dot-files.nix
    ../modules/rbenv.nix
    # inputs.steam-config-nix.homeModules.default
  ];
}
