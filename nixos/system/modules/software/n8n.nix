{ ... }:
{
  services.n8n = {
    enable = true;
  };

  systemd.services.n8n = {
    serviceConfig = {
      Environment = "PATH=/run/current-system/sw/bin";
    };
  };
}
