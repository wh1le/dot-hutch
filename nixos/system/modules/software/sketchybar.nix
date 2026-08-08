{ pkgs, ... }:
let
  luaEnv = pkgs.lua5_5.withPackages (_: [ pkgs.sbarlua ]);
in
{
  environment.systemPackages = [
    (pkgs.runCommand "sketchybar-lua" { } ''
      mkdir -p $out/bin
      ln -s ${luaEnv}/bin/lua $out/bin/sketchybar-lua
    '')
  ];
}
