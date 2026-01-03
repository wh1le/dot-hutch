{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {

        ESP = {
          size = "4G"; # Increased for multiple UKIs
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
            # Disables TRIM for security, enable if you prefer performance/SSD longevity
            settings.allowDiscards = true;
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };

      };
    };

    lvm_vg.pool.type = "lvm_vg";

    lvm_vg.pool.lvs = {
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
}
