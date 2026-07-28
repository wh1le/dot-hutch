{ config, lib, pkgs, ... }:
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "4G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "encrypted";
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "40G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        root = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };

  # Disable device suspend always connected
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{power/control}="on"
  '';

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    i2c.enable = true;
  };

  users.users.${config.my.username}.extraGroups = [ "i2c" ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_12;
    kernelParams = [ "8250.nr_uarts=0" ]; # Serial ports (ttyS0-3) taking 4s. So lets disable
    kernelModules = [
      "hid_apple"
      "kvm-intel"
      "btusb"
      "br_netfilter"
      "dm_crypt"
    ];
    blacklistedKernelModules = [ "iwlwifi" ];
    extraModprobeConfig = ''options hid_apple iso_layout=1 fnmode=2'';
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
  };


  environment.systemPackages = [
    pkgs.ddcutil
  ];
}
