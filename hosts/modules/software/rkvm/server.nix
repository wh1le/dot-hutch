# Server (thinkpad)
{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.rkvm ];

  systemd.services.rkvm-server-cert = {
    description = "Generate rkvm certificates";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /etc/rkvm
      if [ ! -f /etc/rkvm/certificate.pem ]; then
        ${pkgs.rkvm}/bin/rkvm-certificate-gen -i 192.168.50.5 /etc/rkvm/certificate.pem /etc/rkvm/key.pem
      fi
    '';
  };

  environment.etc."rkvm/server.toml".text = ''
    listen = "0.0.0.0:5258"
    switch-keys = ["left-alt", "left-alt"]
    certificate = "/etc/rkvm/certificate.pem"
    key = "/etc/rkvm/key.pem"
    
    [[client]]
    name = "homepc"
    password = "changeme123"
  '';

  networking.firewall.allowedTCPPorts = [ 5258 ];
}
