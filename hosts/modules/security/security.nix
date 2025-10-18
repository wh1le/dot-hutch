{
  pkgs,
  ...
}:

{
  security.sudo.enable = true;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [ openssl ];
}
