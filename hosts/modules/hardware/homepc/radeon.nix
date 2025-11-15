{ config, pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "amdgpu" ];

  environment.variables.GDK_BACKEND = "wayland,x11,*";
  environment.variables.GDK_SCALE = "1.0";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
