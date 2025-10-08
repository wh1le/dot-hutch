{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    paperlike-go
  ];
}
