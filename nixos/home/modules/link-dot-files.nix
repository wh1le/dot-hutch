{
  config,
  pkgs,
  publicRepoUrl,
  ...
}:
let
  homeDirs = [
    "Documents"
    "Videos"
    "Music"
    "Cloud"
    "Code"
    "Virtualization"
    ".local/bin"
    ".local/share"
    ".config/eza"
    ".config/yazi"
  ];

  urlDispatcherSpoon = pkgs.fetchzip {
    url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/URLDispatcher.spoon.zip";
    sha256 = "sha256-T4t70BBWOjmz68jAn5LwKhXffzZ2BWSM00mGv51tiDk=";
    stripRoot = false;
  };

  configSet = builtins.concatStringsSep "," (
    builtins.attrNames (builtins.readDir ../../../home/.config)
  );
  shareSet = builtins.concatStringsSep "," (
    builtins.attrNames (builtins.readDir ../../../home/.local/share)
  );

  downloadDotFilesScript = ''
    #!/usr/bin/env bash

    DOT_PUBLIC="$HOME/Code/dot-hutch"
    PUBLIC_REPO_URL="${publicRepoUrl}"

    git clone --recurse-submodules "$PUBLIC_REPO_URL" "$DOT_PUBLIC"
    cd "$DOT_PUBLIC"
    git submodule update --init --recursive
    echo "Dotfiles cloned. Now run: sudo nixos-rebuild switch --flake ~/Code/dot-hutch#$(hostname)"
  '';
in
{
  home.sessionVariables.IS_MAC = if pkgs.stdenv.isDarwin then "true" else "false";

  home.activation.linkProfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    DOT_HUTCH_GEN_KEY="${configSet}|${shareSet}"
    DOT_PUBLIC="$HOME/Code/dot-hutch"
    PUBLIC_REPO_URL="${publicRepoUrl}"

    # if [ ! -d "$DOT_PUBLIC" ]; then
    #   if ${pkgs.curl}/bin/curl -s --max-time 3 https://github.com >/dev/null 2>&1; then
    #     ${pkgs.git}/bin/git clone --recurse-submodules "$PUBLIC_REPO_URL" "$DOT_PUBLIC"
    #     cd "$DOT_PUBLIC"
    #     ${pkgs.git}/bin/git submodule update --init --recursive
    #   else
    #     ${pkgs.libnotify}/bin/notify-send -u critical "No Internet Connection" "Dotfiles missing. Run: ~/Code/download-missing-dot-files"
    #     mkdir -p "$HOME/Code"
    #     echo "$DOWNLOAD_SCRIPT" > "$HOME/Code/download-missing-dot-files"
    #     chmod +x "$HOME/Code/download-missing-dot-files"
    #     exit 1
    #   fi
    # fi

    ${builtins.concatStringsSep "\n" (map (dir: "mkdir -p ~/${dir}") homeDirs)}

    ${pkgs.bash}/bin/bash "$DOT_PUBLIC/scripts/link-xdg-config.sh" \
       "$HOME/.config" "$DOT_PUBLIC/home/.config"

    ${pkgs.bash}/bin/bash "$DOT_PUBLIC/scripts/link-xdg-config.sh" \
       "$HOME/.local/share" "$DOT_PUBLIC/home/.local/share"

    ln -sfn $DOT_PUBLIC/home/.zshenv $HOME/.zshenv
    ln -sfn $DOT_PUBLIC/home/.Xresources $HOME/.Xresources

    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"

    ln -sfn "$DOT_PUBLIC/home/.local/bin/public" "$HOME/.local/bin/public"

    mkdir -p "$HOME/.local/share/hammerspoon/site/Spoons"
    ln -sfn "${urlDispatcherSpoon}/URLDispatcher.spoon" \
      "$HOME/.local/share/hammerspoon/site/Spoons/URLDispatcher.spoon"

    if [ ! -f $HOME/.current_wallpaper ]; then
      ln -sfn $DOT_PUBLIC/assets/wallpapers/forest.jpg $HOME/.current_wallpaper
    fi
  '';
}
