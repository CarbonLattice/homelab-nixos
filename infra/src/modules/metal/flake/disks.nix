{ hostConfig, ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    # Nixie rejects unknown keys in hosts.json, so a per-host `disk` cannot be set there right now.
    # Every node in this lab has a single NVMe drive, so NVMe is the default instead of /dev/sda.
    device = hostConfig.disk or "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          priority = 2;
          size = "64G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        data = {
          priority = 3;
          size = "100%";
          label = "rook-data";
          content = null;
        };
      };
    };
  };
}
