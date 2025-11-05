{ pkgs, ... }:
{

  # boot.initrd.availableKernelModules = [
  #   "vmd"
  #   "xhci_pci"
  #   "ahci"
  #   "nvme"
  #   "usb_storage"
  #   "usbhid"
  #   "sd_mod"
  # ];

  # boot.kernelModules = [ "kvm-intel" ];
  boot.consoleLogLevel = 3;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 2;

  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [ "i915" ];
  boot.initrd.kernelModules = [ "i915" ];

  # boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.configurationLimit = 10;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.grub.extraEntries = ''
    menuentry "Windows Boot Manager" {
      search --no-floppy --fs-uuid --set=esp FE6B-635E
        chainloader ($esp)/EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';

  boot.plymouth = {
    enable = true;
    font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = [ pkgs.catppuccin-plymouth ];
    theme = "catppuccin-macchiato";
  };
}
