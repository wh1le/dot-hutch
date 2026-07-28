{ pkgs, lib, ... }:
let
  redis-tui = pkgs.buildGoModule {
    pname = "redis-tui";
    version = "master-9e10417";

    src = pkgs.fetchFromGitHub {
      owner = "davidbudnick";
      repo = "redis-tui";
      rev = "9e104173599892bc88a5dec72acfee44acd4ab0b";
      hash = "sha256-QJfn2KvYvkq22G5Rp+eIuhtX/lJFUFxrFGGjXIrZxIw=";
    };

    postPatch = ''
      substituteInPlace go.mod --replace-warn "go 1.26.5" "go 1.26.3"
    '';

    vendorHash = "sha256-i1JhKDh7jvhn7tW9QVfV6eGgt3WgKzZnBXiUHFjOsoQ=";

    meta = {
      description = "Redis TUI Manager";
      homepage = "https://github.com/davidbudnick/redis-tui";
      license = lib.licenses.mit;
      mainProgram = "redis-tui";
    };
  };
in
{
  environment.systemPackages = [ redis-tui ];
}
