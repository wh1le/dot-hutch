{ pkgs, unstable, inputs, ... }:
let
  yazi = inputs.yazi.packages.${pkgs.system}.default;
in
{
  nix.settings = {
    substituters = [ "https://yazi.cachix.org" ];
    trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };

  environment.systemPackages = [
    (yazi.override {
      _7zz = pkgs._7zz-rar;
    })
    pkgs.p7zip
    pkgs.poppler # pdf preview
    pkgs.fd
    pkgs.resvg
    pkgs.exiftool
    pkgs.mediainfo
  ];
}
