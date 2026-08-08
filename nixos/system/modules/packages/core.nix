{ pkgs, unstable, ... }:
{
  environment.systemPackages = [
    pkgs.obsidian
    # unstable.ccusage
  ];
}
