{ ... }:
{
  services.redis.servers."" = {
    enable = true;
    port = 6379;
  };
}
