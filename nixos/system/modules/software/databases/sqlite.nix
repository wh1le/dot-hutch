{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sqlite-web
    pkgs.sqlite
  ];
}
