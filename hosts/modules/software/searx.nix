{ config, sops, self, ... }:
{

  sops.secrets.searx_secret_key.owner = config.users.users.wh1le.name;

  # programs.zsh.shellInit = ''
  #   export SEARX_SECRET_KEY="$(cat ${config.sops.secrets.searx_secret_key.path})"
  # '';

  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 8882;
        bind_address = "127.0.0.1";
        secret_key = "@SEARX_SECRET_KEY@";
      };
      search = { formats = [ "html" "json" ]; };
    };
    environmentFile = config.sops.templates.searx-env.path;

    limiterSettings = {
      botdetection.ip_lists.allow_ip = [ "192.168.50.3" ];
    };
  };
  sops.templates.searx-env = {
    content = ''
      SEARX_SECRET_KEY=${config.sops.placeholder.searx_secret_key}
    '';
  };
}
