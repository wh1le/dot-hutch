{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    veracrypt
    gnutar
  ];
}
