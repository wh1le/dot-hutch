{ ... }:
{
  services.redlib = {
    enable = true;

    address = "127.0.0.1";
    port = 8300;

    settings = {
      REDLIB_ROBOTS_DISABLE_INDEXING = true;
    };
  };
}
