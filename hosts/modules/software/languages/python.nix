{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.python3.withPackages (ps: [
      ps.pynvim

      ps.tldextract
      ps.debugpy
      ps.pygobject3
      ps.requests
      ps.adblock
    ]))
  ];
}
