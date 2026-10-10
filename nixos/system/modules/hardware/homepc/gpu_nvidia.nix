{ config, pkgs, lib, inputs, ... }:
let
  # DLSS 5's neural rendering is NGX feature 18, which the 595 production branch --
  # the newest NVIDIA driver in the pinned nixos-26.05 -- does not implement: the
  # DLSS5VKLayer helper blocks in CreateFeature and never evaluates a frame.
  # unstable's new_feature branch is 610.57.04, the version that stack reports
  # success on for Ada. The driver builds against the kernel we boot, so kernel
  # and driver both come from that input, staying on the 6.12 series that
  # hardware-configuration.nix pins.
  # import rather than legacyPackages: this second nixpkgs has to be given the
  # system's own nixpkgs.config (allowUnfree, nvidia.acceptLicense), otherwise the
  # driver fails evaluation with "Refusing to evaluate package 'nvidia-x11-610.57.04'
  # because it has an unfree license".
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = pkgs.config;
  };
in
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

  # 610.57.04 for DLSS 5 NR. auto-patch applies the NVENC/NvFBC unlock for drivers
  # the nvidia-patch input knows and skips it for those it does not, so a driver
  # bump can never fail the build the way patch-nvenc (patch-fbc ...) does with
  # "error: attribute '610.57.04' missing". Requires the nvidia-patch input to be
  # recent enough to list this driver, or the unlock is silently lost.
  hardware.nvidia.package = pkgs.nvidia-patch.auto-patch unstable.linuxPackages_6_12.nvidiaPackages.new_feature;
  hardware.nvidia.nvidiaSettings = true;

  # Must be the kernel set the 610 driver above is built against. mkForce because
  # hardware-configuration.nix also sets boot.kernelPackages (26.05's 6.12).
  boot.kernelPackages = lib.mkForce unstable.linuxPackages_6_12;

  # boot.extraModulePackages used to list config.boot.kernelPackages.nvidia_x11,
  # which is nvidiaPackages.stable -- 595 production in the unstable input. The
  # nvidia module already sets extraModulePackages from hardware.nvidia.package,
  # so that line would put a second, older driver module in the closure and initrd.
  boot.initrd.kernelModules = [ "nvidia" ];
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
