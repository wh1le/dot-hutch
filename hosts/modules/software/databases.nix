{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sqlitebrowser
  ];
}
