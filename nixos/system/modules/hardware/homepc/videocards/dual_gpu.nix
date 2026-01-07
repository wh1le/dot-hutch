{ config, pkgs, unstable, ... }:

# =============================================================================
# GPU Offload Notes (Radeon display + 4090 compute)
# =============================================================================
#
# STATUS: Games work perfectly on 4090. SteamVR desktop mirroring WIP.
#
# HYPRLAND CONFIG (required for NVIDIA offload):
#
#   xwayland {
#     force_zero_scaling = true
#   }
#   cursor {
#     no_warps = false        # Fixes cursor jumps with multi-GPU
#   }
#   general {
#     allow_tearing = true    # Reduces input latency in games
#   }
#   env = WLR_DRM_NO_ATOMIC,1 # Required for NVIDIA on Wayland
#
# STEAM LAUNCH OPTIONS:
#   SteamVR:
#     QT_QPA_PLATFORM=xcb __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command% --gpu-number=1
#
#   ArcRaiders (and other X11-only titles):
#      SDL_VIDEODRIVER=x11 PROTON_ENABLE_WAYLAND=0
#
# =============================================================================

{
  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.GDK_SCALE = "1.0";
  environment.variables.DUAL_GPU_SETUP_ENABLED = 1;
  # Force wayland to use Radeon card https://wiki.hypr.land/Configuring/Multi-GPU/
  environment.variables.AQ_DRM_DEVICES = "/dev/dri/amd-gpu";
  # environment.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

  boot.initrd.kernelModules = [
    "amdgpu"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];

  nixpkgs.config.cudaSupport = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.package = unstable.mesa;
  hardware.graphics.package32 = unstable.pkgsi686Linux.mesa;
  hardware.graphics.extraPackages = with pkgs; [
    unstable.mesa
    rocmPackages.clr.icd

    nvidia-vaapi-driver
    libva
  ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  # hardware.nvidia.package = unstableKernelPkgs.nvidiaPackages.stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    amdgpuBusId = "PCI:9:0:0"; # Radeon RX 7600
    nvidiaBusId = "PCI:1:0:0"; # Nvidia 4090
  };


  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
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

  virtualisation.docker.enableNvidia = true;

  environment.systemPackages = [
    pkgs.cudaPackages.cuda-samples

    pkgs.nvtopPackages.full
    pkgs.lshw
    pkgs.pciutils
    pkgs.vulkan-tools
    pkgs.mesa-demos
    pkgs.egl-wayland # NVIDIA's EGL external platform library for Wayland compositors.

    pkgs.cudaPackages.cudatoolkit
    unstable.nvidia-vaapi-driver
    pkgs.cudaPackages.cuda_cudart
  ];
}
