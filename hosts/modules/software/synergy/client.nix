{ pkgs, ... }: {
  services.synergy.client = {
    enable = true;
    screenName = "homepc";
    serverAddress = "192.168.50.5:24800";
  };
}
