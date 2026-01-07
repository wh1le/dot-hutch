{ self, config, pkgs, ... }:
let
  userHome = "/home/${config.home.username}";
  dotPublic = "${userHome}/dot/dot-hutch";

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
    DOT_HUTCH_FILES="$HOME/dot/dot-hutch"

    ${pkgs.libnotify}/bin/notify-send -u critical "Dotfiles Missing" "Dotfiles are missing and no internet connection.\nPlease execute:\n$HOME/dot/download-missing-dot-files\nThen rebuild NixOS."

    if [ ! -d "$DOT_HUTCH_FILES" ]; then
      if ${pkgs.curl}/bin/curl -s --max-time 3 https://github.com >/dev/null 2>&1; then
        ${pkgs.git}/bin/git clone --recurse-submodules https://github.com/wh1le/dot-hutch.git $DOT_HUTCH_FILES
        cd DOT_HUTCH_FILES
        ${pkgs.git}/bin/git submodule update --init --recursive
      else
        ${pkgs.libnotify}/bin/notify-send -u critical "Dotfiles Missing" "Dotfiles are missing and no internet connection.\nPlease execute:\n$HOME/dot/download-missing-dot-files\nThen rebuild NixOS."
      fi
    fi

    ${builtins.concatStringsSep "\n" (map (dir: "mkdir -p ~/${dir}") homeDirs)}

    ${pkgs.bash}/bin/bash "$DOT_HUTCH_FILES/scripts/linking/deploy-xdg-config.sh" \
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
