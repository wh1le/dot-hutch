{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sbarlua
  ];
}
