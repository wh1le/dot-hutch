{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

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

  boot = {
    initrd = {
      enable = true;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "amdgpu" ];
    };
    supportedFilesystems = [ "nfs" ];

    kernelParams = [
      "amd_iommu=on" # Already have amd_pstate=active elsewhere
      "iommu=pt" # Passthrough mode, helps with wake
      "acpi_osi=Linux" # Better ThinkPad ACPI support
      "acpi_backlight=native"
      # "video.brightness_switch_enabled=0"
      # "amdgpu.dcdebugmask=0x200" # Radeon 780M (Phoenix1): disable Panel Replay / power feature causing flicker/stutter
    ];
  };

  services.fwupd.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # for Steam/gaming
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    firmware = [ pkgs.linux-firmware ];
    amdgpu.initrd.enable = lib.mkDefault true;
  };

  services.thinkfan = {
    enable = true;
    sensors = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/thermal"; indices = [ 0 ]; }
    ];

    fans = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; }
    ];

    levels = [
      [ 1 0 35 ] # Fan off until 35°C
      [ 2 30 45 ] # Level 1: 30-45°C (starts at 35°C)
      [ 3 40 55 ] # Level 2: 40-55°C
      [ 4 50 60 ] # Level 3: 50-60°C
      [ 6 55 65 ] # Level 4: 55-65°C
      [ 7 60 70 ] # Level 5: 60-70°C
      [ 7 65 75 ] # Level 6: 65-75°C
      [ 7 70 32767 ] # Full speed: 70°C+
    ];
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event*", ATTRS{name}=="SYNA8018:00 06CB:CE67 Touchpad", \
      ENV{LIBINPUT_ATTR_TAPPING_ENABLED}="1", \
      ENV{LIBINPUT_ATTR_TAP_DRAG_LOCK_ENABLED}="1", \
      ENV{LIBINPUT_ATTR_NATURAL_SCROLLING_ENABLED}="1", \
      ENV{LIBINPUT_ATTR_DISABLE_WHILE_TYPING_ENABLED}="1"
  '';

  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  systemd.services.ModemManager.enable = lib.mkForce false;
  services.printing.browsed.enable = false;

  environment.systemPackages = [ pkgs.xrdb ];

  networking = {
    # DHCP handled by NetworkManager
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
      };
    };
    timeServers = [ "0.nixos.pool.ntp.org" ];
    wireless.extraConfig = ''country=PT'';
  };

  # fix for suspend
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/modprobe -r ath11k_pci && ${pkgs.kmod}/bin/modprobe ath11k_pci
    ${pkgs.networkmanager}/bin/nmcli nm sleep false
  '';


}

