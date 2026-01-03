{ pkgs, unstable, ... }:
{


  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [
      "hid_apple"
      "kvm-intel"
      "btusb"
      "br_netfilter"
    ];

    # Serial ports (ttyS0-3) taking 4s. So lets disable
    kernelParams = [ "8250.nr_uarts=0" ];

    extraModprobeConfig = ''
      options hid_apple iso_layout=0 fnmode=2
    '';

    initrd = {
      enable = true;

      systemd.enable = true;

      kernelModules = [ "vmd" ];

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

    loader = {
      timeout = 5;

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    # plymouth = {
    #   enable = true;
    #   font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    #   themePackages = [ pkgs.catppuccin-plymouth ];
    #   theme = "catppuccin-macchiato";
    # };
  };
}
