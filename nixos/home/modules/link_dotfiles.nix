{ config
, pkgs
, ...
}:
let
  home = config.home.homeDirectory;
  git = "${pkgs.git}/bin/git";
  ssh = "${pkgs.openssh}/bin/ssh";
  sshKey = "${home}/.ssh/nixos";
in
{
  home.activation.clone-dot-files = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    export repo="git@github.com:wh1le/dot-files.git"
    export destination="${config.home.homeDirectory}/dot/files"

    if [ ! -f "${sshKey}" ]; then
      echo "Missing SSH key ${sshKey}" >&2
      exit 1
    fi

    export GIT_SSH_COMMAND='${ssh} -oBatchMode=yes -i ${sshKey} -F /dev/null'

    if [ ! -d $destination/.git ]; then
      mkdir -p "$(dirname $destination)"
      ${git} clone $repo $destination
    fi

    ln -sfn $destination/home/.zprofile ${home}/.zprofile
    ln -sfn $destination/home/.zprofile ${home}/.profile # need this to propagate env variables to hyprland session so I can have env variibles on auto-start
    ln -sfn $destination/home/.zshenv ${home}/.zshenv

    mkdir -p "${home}/.local/bin"
    ln -sfn "${home}/dot/files/home/.local/bin/public" "${home}/.local/bin/public"
    ln -sfn "${home}/dot/files/home/.local/share/darkman" "${home}/.local/share/darkman"

    src="$destination/home/.config"
    dst="${home}/.config"

    mkdir -p "$dst"

    for item in "$src"/*; do
      name=$(basename "$item")

      target="$dst/$name"

      if [ -L "$target" ]; then # already a symlink
        current="$(readlink -- "$target")"

        if [ "$current" = "$item" ]; then # points to correct place, skip
          continue
        else
          rm -f -- "$target"
        fi
      elif [ -e "$target" ]; then
        rm -rf -- "$target" # remove real path: $target
      fi

      ln -s "$item" "$target"
    done
  '';

  home.activation.clone-dot-nix = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    export repo="git@github.com:wh1le/dot-nix.git"
    export destination="${config.home.homeDirectory}/dot/nix-public"

    if [ ! -f "${sshKey}" ]; then
      echo "Missing SSH key ${sshKey}" >&2
      exit 1
    fi

    export GIT_SSH_COMMAND='${ssh} -oBatchMode=yes -i ${sshKey} -F /dev/null'

    if [ ! -d $destination/.git ]; then
      mkdir -p "$(dirname $destination)"
      ${git} clone $repo $destination
    fi
  '';

  home.activation.clone-dot-wallpapers = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    export repo="git@github.com:wh1le/dot-wallpapers.git"
    export destination="${config.home.homeDirectory}/dot/wallpapers"

    if [ ! -f "${sshKey}" ]; then
      echo "Missing SSH key ${sshKey}" >&2
      exit 1
    fi

    export GIT_SSH_COMMAND='${ssh} -oBatchMode=yes -i ${sshKey} -F /dev/null'

    if [ ! -d $destination/.git ]; then
      mkdir -p "$(dirname $destination)"
      ${git} clone $repo $destination
    fi
  '';
}
