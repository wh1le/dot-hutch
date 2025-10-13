{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ffmpeg
    vlc
    libva-utils
    nvidia-vaapi-driver
    mpv
  ];
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
