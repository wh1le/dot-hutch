{ lib, ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers.elasticsearch = {
      image = "docker.elastic.co/elasticsearch/elasticsearch:8.17.3";
      ports = [ "127.0.0.1:9200:9200" ];
      volumes = [ "elasticsearch-data:/usr/share/elasticsearch/data" ];
      environment = {
        "discovery.type" = "single-node";
        "cluster.name" = "local-dev";
        "xpack.security.enabled" = "false"; # local dev — no TLS/auth
        "xpack.ml.enabled" = "false"; # embed app-side, ES doesn't need ML
        "ES_JAVA_OPTS" = "-Xms1g -Xmx1g";
      };
    };
  };

  systemd.services.podman-elasticsearch.wantedBy = lib.mkForce [ ]; # keep your no-autostart behavior
  boot.kernel.sysctl."vm.max_map_count" = 262144; # or ES 8 won't boot
}
