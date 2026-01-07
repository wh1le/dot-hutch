{ self, config, pkgs, ... }:
let
  userHome = "/home/${config.home.username}";
  dotPublic = "${userHome}/dot/nix-public";

  homeDirs = [
    "Documents"
    "Videos"
    "Music"
    "Cloud"
    "Code"
    "Projects"
    "Virtualization"
    ".local/bin"
    ".local/bin/public"
    ".local/share"
  ];
in
{
  # TODO: Might need to remove it, and clone submodules manually because it could block home-mamanger if no internet connection
  # home.activation.cloneSubmodules = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #   ${pkgs.git}/bin/git -C ${dotPublic} submodule update --init --recursive
  # '';

  home.activation.linkProfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    DOT_HUTCH_FILES="$HOME/dot/nix-public"

    if [ ! -d "$DOT_HUTCH_FILES" ]; then
      ${pkgs.git}/bin/git clone --recurse-submodules https://github.com/wh1le/dot-hutch.git $DOT_HUTCH_FILES
    fi

    ${builtins.concatStringsSep "\n" (map (dir: "mkdir -p ~/${dir}") homeDirs)}

    ${pkgs.bash}/bin/bash "$DDT_PUBLIC/scripts/linking/deploy-xdg-config.sh" \
       "$HOME/.config" "$DOT_HUTCH_FILES/home/.config"

    ln -sfn $DOT_HUTCH_FILES/home/.zshenv $HOME/.zshenv
    ln -sfn $DOT_HUTCH_FILES/home/.zprofile $HOME/.zprofile
    ln -sfn $DOT_HUTCH_FILES/home/.zprofile $HOME/.profile

    mkdir -p $HOME/.local/bin

    ln -sfn $DOT_HUTCH_FILES/home/.local/bin/public $HOME/.local/bin/public

    if [ ! -f $HOME/.current_wallpaper ]; then
      ln -sfn $DOT_HUTCH_FILES/assets/wallpapers/forest.jpg $HOME/.current_wallpaper
    fi

    mkdir -p $HOME/.ssh

    ln -sfn $DOT_HUTCH_FILES/home/.ssh/config $HOME/.ssh/config
  '';
}
