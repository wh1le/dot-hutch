{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [
      ps.debugpy
      ps.requests
    ]))
  ];
}
