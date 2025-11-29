{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [
      "myapp_development"
      "myapp_test"
    ];
    ensureUsers = [
      {
        name = "postgres";
      }
    ];
    settings = {
      # relax a bit for dev if needed
      max_connections = 100;
    };
  };
}
