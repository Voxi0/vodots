let
  # System disk where the OS lives
  primaryDisk = "/dev/sda";
in {
  disko.devices.disk = {
    # Primary/System disk
    primary = {
      device = primaryDisk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # Boot partition
          esp = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          # Root partition
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
