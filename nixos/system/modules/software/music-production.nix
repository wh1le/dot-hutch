{ pkgs, lib, ... }:

let
  allPlugins = lib.filter lib.isDerivation (lib.attrValues pkgs.supercolliderPlugins);
in
{

  environment.systemPackages = [
    (pkgs.supercollider-with-plugins.override {
      supercollider = pkgs.supercollider_scel;
      plugins = allPlugins;
    })
  ];
}
