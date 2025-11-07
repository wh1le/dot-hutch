{
  config,
  pkgs,
  ...
}:
let
  git = "${pkgs.git}/bin/git";
  ssh = "${pkgs.openssh}/bin/ssh";
  sshKey = "${config.home.homeDirectory}/.ssh/nixos";
in
{
  home.activation.clone-dot-files = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    export repo="git@github.com:wh1le/dot-files.git"
    export destination="${config.home.homeDirectory}/dot-test/files"

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

  home.activation.clone-dot-nix = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    set -eu

    export repo="git@github.com:wh1le/dot-nix.git"
    export destination="${config.home.homeDirectory}/dot-test/nix-public"

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
    export destination="${config.home.homeDirectory}/dot-test/wallpapers"

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

  # Single files from repo::/home/
  # home.file.".xprofile".source = "${dot}/home/.xprofile";
  # home.file.".zprofile".source = "${dot}/home/.zprofile";

  # entries = builtins.attrNames (builtins.readDir "${dot}/home/.config");
  #
  # xdg.configFile = lib.genAttrs entries (name: {
  #   source = "${dot}/home/.config/${name}";
  # });
}
