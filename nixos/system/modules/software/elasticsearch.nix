{ pkgs, lib, ... }:
{
  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch.override { jre_headless = pkgs.temurin-jre-bin-11; };
    single_node = true;
    listenAddress = "127.0.0.1";
    port = 9200;
    tcp_port = 9300;
    cluster_name = "local-dev";
    extraJavaOptions = [ "-XX:-UseBiasedLocking" ];
  };

  systemd.services.elasticsearch.wantedBy = lib.mkForce [ ];
}
