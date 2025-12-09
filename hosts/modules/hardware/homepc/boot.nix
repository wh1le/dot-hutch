{ pkgs, unstable, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = [
    "hid_apple"
    "kvm-intel"
    "btusb"
  ];

  boot.extraModprobeConfig = ''options hid_apple iso_layout=0 fnmode=2'';

  boot.initrd = {
    enable = true;

    systemd.enable = true;

    kernelModules = [
      "vmd"
    ];

    availableKernelModules = [
      "xhci_pci" # USB3 controller (keyboards, mice, hubs)
      "ahci" # Intel SATA controller
      "nvme" # NVMe controller for nvme0n1
      "usb_storage" # USB mass storage (external drives)
      "usbhid" # Generic USB HID (keyboard, mouse)
      "sd_mod" # SCSI disk layer
      # "vmd" # Intel VMD / RAID path (safe to keep)

      # "i915"
    ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 2;

  # boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.configurationLimit = 10;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # boot.loader.grub.extraEntries = ''
  #   menuentry "Windows Boot Manager" {
  #     search --no-floppy --fs-uuid --set=esp FE6B-635E
  #       chainloader ($esp)/EFI/Microsoft/Boot/bootmgfw.efi
  #   }
  # '';

  # boot.consoleLogLevel = 3;

  # boot.plymouth = {
  #   enable = true;
  #   font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
  #   themePackages = [ pkgs.catppuccin-plymouth ];
  #   theme = "catppuccin-macchiato";
  # };
}
