{
  pkgs,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  }; # 32-bit libs for Wine/Proton

  services.flatpak.enable = true;
  programs.appimage.enable = true;

  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    winetricks
    dxvk
    lutris
  ];

}
