{ pkgs, lib, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
  hardware.amdgpu.initrd.enable = lib.mkDefault true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # for Steam/gaming
  };

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    # rocmPackages.clr.icd
  ];
}
