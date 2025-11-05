{
  pkgs,
  ...
}:

{
  security.sudo.enable = true;
  # security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    openssl
  ];
}
