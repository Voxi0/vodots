let
  systemDisk = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S2RANX0H637158A";
  mountOptions = ["noatime" "compress=zstd" "discard=async"];
in {
  # Ensure "/nix" exists during boot since it's required to make sure the system is ready
  fileSystems."/nix".neededForBoot = true;

  # Disk layout
  disko.devices = {
    # Ephemeral root partition wiped whenever the device is powered off or reboots
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=25%" "mode=755"];
    };

    # Primary system disk
    disk.primary = {
      device = systemDisk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # EFI/Boot partiton required for UEFI
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          # Persistent partition
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                # Required for system to boot
                "/nix" = {
                  inherit mountOptions;
                  mountpoint = "/nix";
                };

                # Stuff the user wants persistent
                "/persistent" = {
                  inherit mountOptions;
                  mountpoint = "/persistent";
                };
              };
            };
          };
        };
      };
    };
  };
}
