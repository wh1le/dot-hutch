{ config, pkgs, unstable, ... }:

{
  nix.settings = {
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };
  nixpkgs.config.cudaSupport = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];

  # environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.GDK_SCALE = "1.0";
  environment.variables.DUAL_GPU_SETUP_ENABLED = 1;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.package = unstable.mesa;
  hardware.graphics.package32 = unstable.pkgsi686Linux.mesa;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd

    nvidia-vaapi-driver
    libva
  ];

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  # hardware.nvidia.package = unstableKernelPkgs.nvidiaPackages.stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    amdgpuBusId = "PCI:9:0:0"; # Radeon RX 7600
    nvidiaBusId = "PCI:1:0:0"; # Nvidia 4090
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

  # Force wayland to use Radeon card https://wiki.hypr.land/Configuring/Multi-GPU/
  environment.variables.AQ_DRM_DEVICES = "/dev/dri/amd-gpu";

  environment.systemPackages = [
    pkgs.nvtopPackages.full
    pkgs.lshw
    pkgs.pciutils
    pkgs.vulkan-tools
    pkgs.mesa-demos

    pkgs.cudaPackages.cudatoolkit
    unstable.nvidia-vaapi-driver
    pkgs.cudaPackages.cuda_cudart
  ];
}
