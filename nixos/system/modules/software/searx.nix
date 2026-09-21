{ config, ... }:
{

  sops.secrets.searx_secret_key = {
    owner = "searx";
    mode = "0400";
  };

  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 8882;
        bind_address = "127.0.0.1";
        secret_key = "@SEARX_SECRET_KEY@";
      };
      search = {
        formats = [
          "html"
          "json"
        ];
      };
    };
    environmentFile = config.sops.secrets.searx_secret_key.path;

    limiterSettings = {
      botdetection.ip_lists.allow_ip = [
        # "homepc ip here"
      ];
    };
  };
}
