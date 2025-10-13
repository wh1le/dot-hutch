{
  pkgs,
  ...
}:

{
  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    openssl
  ];
}
