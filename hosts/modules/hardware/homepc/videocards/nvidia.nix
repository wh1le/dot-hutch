{ config, pkgs, ... }:
{
  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.WLR_NO_HARDWARE_CURSORS = 1;
  environment.variables.NVIDIA_CARD_PRIMARY = 1;

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";

    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";

    _JAVA_AWT_WM_NONREPARENTING = "1";
    WLR_RENDERER = "vulkan";
    GTK_USE_PORTAL = "1";
    # TODO: might break portal
    # NIXOS_XDG_OPEN_USE_PORTAL = "1";
    ENABLE_VKBASALT = "1";
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true; # Enable access to nvidia from containers (Docker, Podman)
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.nvidiaSettings = true;

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    lshw
    mesa-demos
  ];
}
