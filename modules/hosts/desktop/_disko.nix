let
  # System disk where the OS lives
  primaryDisk = "/dev/sda";
in {
  disko.devices = {
    # RAM filesystem to mount the root
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=2G"
        "mode=755"
      ];
    };

    # Primary/System disk
    disk.primary = {
      device = primaryDisk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # Boot partition
          esp = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          # Root partition
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Force overwrite
              subvolumes = {
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
              };
            };
          };
        };
      };
    };
  };
}