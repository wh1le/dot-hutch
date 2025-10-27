{lib,...}:

let
  KHOLE_IP = "192.168.1.253";
  KHOLE_ROUTER_IP = "192.168.1.254";
in
{
  networking.hostName = "khole";

  networking = {
    wireless.enable = false;

    useDHCP = lib.mkForce false;

    # Use unbound to resolve DNS
    nameservers = [ "127.0.0.1" ];

    defaultGateway = {
      address = KHOLE_ROUTER_IP;
      interface = "eth0";
    };

    interfaces = {
      "eth0" = {
        useDHCP = lib.mkForce false;

        ipv4.addresses = [
          {
            address = KHOLE_IP;
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
