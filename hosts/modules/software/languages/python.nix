{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [
      ps.pynvim

      ps.debugpy
      ps.pygobject3
      ps.requests
    ]))
  ];
}
