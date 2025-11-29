{ pkgs, ... }:
{
  services.redis = {
    enable = true;
    package = pkgs.redis;
    port = 6379;
  };
}
