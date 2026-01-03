{ pkgs, lib, config, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # services.firmware.enable = true;

  boot.kernelParams = [
    "apm=power_off"
    "pcie_aspm=force" # Helps AMD power saving
    "amd_pstate=active" # Enable kernel features for power monitoring
    "initcall_debug" # Helps debug if drivers fail to load
  ];

  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = -1; # Unlock the kernel stats for powertop 
  };

  boot.kernelModules = [
    "hid_apple"
    "kvm-amd"
    "btusb"
    "thinkpad_acpi"
  ];

  boot.extraModulePackages = [ ];

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0 fnmode=2
    options thinkpad_acpi fan_control=1
  '';

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

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  environment.systemPackages = [
    pkgs.sbctl # boot keys generation
  ];
}
