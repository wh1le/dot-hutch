{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    # Optional: Hint to use VA-API (Video Acceleration) on Radeon by default
    # because browsers/video players run on the desktop GPU.
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.GDK_SCALE = "1.0";
  environment.variables.DUAL_GPU_SETUP_ENABLED = 1;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    amdvlk
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.open = true;

  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;

  # Pass throw:
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    amdgpuBusId = "PCI:9:0:0"; # The card connected to monitors (Radeon)
    nvidiaBusId = "PCI:1:0:0"; # The card for Compute/Gaming (Nvidia 4090)
  };

  # get id of gpu
  # lspci -d ::03xx | grep 'AMD' | cut -f1 -d' '

  services.udev.extraRules = ''
    KERNEL=="card*", \
      KERNELS=="0000:09:00.0", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/amd-gpu"

    KERNEL=="card*", \
      KERNELS=="0000:01:00.0", \
      SUBSYSTEM=="drm", \
      SUBSYSTEMS=="pci", \
      SYMLINK+="dri/nvidia-gpu"
  '';

  # Force wayland to use Radeon card
  # https://wiki.hypr.land/Configuring/Multi-GPU/
  environment.variables.AQ_DRM_DEVICES = "/dev/dri/amd-gpu";

  environment.systemPackages = with pkgs; [
    lshw
    pciutils
    nvtopPackages.full
    vulkan-tools
    nvidia-vaapi-driver
    glxinfo
  ];
}
