{ self, config, pkgs, ... }:
let
  userHome = "/home/${config.home.username}";
  dotPublic = "${userHome}/dot/nix-public";

  homeDirs = [
    "Documents"
    "Videos"
    "Music"
    "Cloud"
    "code"
    "Projects"
    "Virtualization"
    ".local/bin"
    ".local/share"
  ];
in
{
  home.activation.createDirs = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    ${builtins.concatStringsSep "\n" (map (dir: "mkdir -p ~/${dir}") homeDirs)}
  '';

  home.activation.linkConfigs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.bash}/bin/bash ${self}/scripts/linking/deploy-xdg-config.sh "${userHome}/.config" "${dotPublic}/home/.config"
  '';

  home.activation.linkScripts = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${userHome}/.local/bin

    ln -sfn ${dotPublic}/home/.local/bin/public ${userHome}/.local/bin/public
    ln -sfn ${dotPublic}/home/.local/share/darkman ${userHome}/.local/share/darkman
  '';

  home.activation.cloneSubmodules = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.git}/bin/git -C ${dotPublic} submodule update --init --recursive
  '';
}
