{ config, pkgs, inputs, ... }:
{
  # NvFBC unlock for SteamVR/wlx-overlay-s GPU desktop capture on consumer GPU.
  nixpkgs.overlays = [ inputs.nvidia-patch.overlays.default ];

  environment.sessionVariables = {
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
    NVIDIA_CARD_PRIMARY = "1";

    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_USE_PORTAL = "1";
    # TODO: might break portal
    # NIXOS_XDG_OPEN_USE_PORTAL = "1";
    # ENABLE_VKBASALT = "1";
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.screenSection = ''
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaPersistenced = true;

  # hardware.nvidia.powerManagement.enable = true;
  # hardware.nvidia.powerManagement.finegrained = false;

  hardware.nvidia.package = pkgs.nvidia-patch.patch-nvenc
    (pkgs.nvidia-patch.patch-fbc config.boot.kernelPackages.nvidiaPackages.production);
  hardware.nvidia.nvidiaSettings = true;

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
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
