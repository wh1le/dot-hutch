{ pkgs, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # for Steam/gaming
  };

  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
    rocmPackages.clr.icd # OpenCL
  ];
}
