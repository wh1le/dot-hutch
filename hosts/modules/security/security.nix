{
  pkgs,
  ...
}:

{
  security.sudo.enable = true;
  # security.polkit.enable = true;

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    openssl
  ];
}
