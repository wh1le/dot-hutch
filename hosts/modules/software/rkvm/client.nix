{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.rkvm ];

  sops.secrets."rkvm/certificate" = {
    sopsFile = ../../../../secrets/default.yaml;
    path = "/etc/rkvm/certificate.pem";
    mode = "0444";
  };

  environment.etc."rkvm/client.toml".text = ''
    server = "192.168.50.5:5258"
    password = "changeme123"
    certificate = "/etc/rkvm/certificate.pem"
  '';
}
