{
  pkgs,
  ...
}:

{
  security.sudo.enable = true;
  services.openssh.enable = true;

  # security.polkit.enable = true;

  environment.systemPackages = with pkgs; [ openssl ];
}
