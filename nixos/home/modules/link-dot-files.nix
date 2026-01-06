{ config, pkgs, ... }:
let
  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  homeDir = "/home/${config.home.username}";
  dotPublic = "${homeDir}/dot/nix-public";
  configDir = ../../../home/.config; # adjust based on actual location
  configEntries = builtins.readDir configDir;
  excludeDirs = [ "systemd" ];

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

  home.activation.cloneSubmodules = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.git}/bin/git -C ${dotPublic} submodule update --init --recursive
  '';

  home.file.".local/bin/public".source = mkSymlink "${dotPublic}/home/.local/bin/public";
  home.file.".local/share/darkman".source = mkSymlink "${dotPublic}/home/.local/share/darkman";

  xdg.configFile = builtins.mapAttrs
    (name: _: {
      source = mkSymlink "${dotPublic}/home/.config/${name}";
    })
    (removeAttrs configEntries excludeDirs);
}
