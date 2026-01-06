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

  home.activation.createDirs = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    ${builtins.concatStringsSep "\n" (map (dir: "mkdir -p ~/${dir}") homeDirs)}
  '';

  home.activation.linkXDGConfigs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn ${dotPublic}/home/.zshenv ${userHome}/.zshenv

    ${pkgs.bash}/bin/bash ${self}/scripts/linking/deploy-xdg-config.sh "${userHome}/.config" "${dotPublic}/home/.config"
  '';

  home.activation.linkProfiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn ${dotPublic}/home/.zprofile ${userHome}/.zprofile
    ln -sfn ${dotPublic}/home/.zprofile ${userHome}/.profile
  '';

  home.activation.linkScripts = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${userHome}/.local/bin

    ln -sfn ${dotPublic}/home/.local/bin/public ${userHome}/.local/bin/public
  '';

  home.activation.linkSSH = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${userHome}/.ssh

    ln -sfn ${dotPublic}/home/.ssh/config ${userHome}/.ssh/config
  '';
}
