{ pkgs, config, ... }:
let
  host = config.networking.hostName;
in
{
  sops.secrets.proton_bridge_password = {
    key = "${host}/proton_bridge_password";
    owner = config.my.username;
    mode = "0400";
  };

  services.protonmail-bridge = {
    enable = true;
    path = [ pkgs.pass ];
  };
}
