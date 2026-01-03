{ lib, pkgs, ... }:
let
  swap_drive = "/dev/disk/by-uuid/660e220f-ab87-4b0c-ab85-3249468a5487";
in
{
  boot.initrd = {
    systemd.enable = true;
    kernelModules = [ "amdgpu" ];
    availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "thunderbolt"

      "tpm_tis"
      "tpm_crb"
    ];
  };

  environment.systemPackages = [
    pkgs.sbctl
  ];

  boot.loader = {
    systemd-boot = {
      enable = false;
      configurationLimit = 5;
    };
    timeout = 1;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.kernelParams = [
    "resume=${swap_drive}"
  ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a779eb63-1521-41b6-a616-72362c1afe0b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BD95-BDFE";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [{ device = swap_drive; }];


  # disko.devices.disk.main = {
  #   type = "disk";
  #   device = "/dev/nvme0n1";
  #   content = {
  #     type = "gpt";
  #     partitions = {
  #
  #       ESP = {
  #         size = "4G"; # Increased for multiple UKIs
  #         type = "EF00";
  #         content = {
  #           type = "filesystem";
  #           format = "vfat";
  #           mountpoint = "/boot";
  #         };
  #       };
  #
  #       luks = {
  #         size = "100%";
  #         content = {
  #           type = "luks";
  #           name = "encrypted";
  #           # Disables TRIM for security, enable if you prefer performance/SSD longevity
  #           settings.allowDiscards = true;
  #           content = {
  #             type = "lvm_pv";
  #             vg = "pool";
  #           };
  #         };
  #       };
  #
  #     };
  #   };
  #
  #   lvm_vg.pool.type = "lvm_vg";
  #
  #   lvm_vg.pool.lvs = {
  #     swap = {
  #       size = "40G";
  #       content = {
  #         type = "swap";
  #         resumeDevice = true;
  #       };
  #     };
  #
  #     root = {
  #       size = "100%FREE";
  #       content = {
  #         type = "filesystem";
  #         format = "ext4";
  #         mountpoint = "/";
  #       };
  #     };
  #   };
  # };
}
