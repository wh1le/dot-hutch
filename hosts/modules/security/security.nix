{ pkgs, unstable, ... }:
{
  security.sudo.enable = true;
  # security.polkit.enable = true;

  security.rtkit.enable = true;

  environment.systemPackages = [
    unstable.openssl
  ];
}
