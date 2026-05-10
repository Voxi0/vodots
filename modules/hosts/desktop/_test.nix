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
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        mountpoint = "/";

        # Workaround: cannot import 'zroot': I/O error in disko tests
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };

        datasets = {
          # Volatile root which gets wiped on every reboot
          root = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs snapshot zroot/root@blank";
            # options."com.sun:auto-snapshot" = "true";
          };

          # Persistent store which won't get wiped
          persist = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };

          # The Nix store - Obviously shouldn't be wiped or else everything is done for
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}