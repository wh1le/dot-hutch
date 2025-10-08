{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # --- Wine --- #
    wineWowPackages.stable # support both 32-bit and 64-bit applications
    (wine.override { wineBuild = "wine64"; }) # support 64-bit only
    wine64 # support 64-bit only
    wineWowPackages.staging # wine-staging (version with experimental features)
    winetricks # winetricks (all versions)
    wineWowPackages.waylandFull # native wayland support (unstable)
    # --- Wine --- #
  ];
}
