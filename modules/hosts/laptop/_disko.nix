let
  systemDisk = "/dev/disk/by-id/ata-CT240BX500SSD1_2026E403825E";
  mountOptions = ["noatime" "compress=zstd"];
in {
  # Ensure "/nix" is available during boot
  fileSystems."/nix".neededForBoot = true;

  # Disko
  disko.devices = {
    # Ephemeral root partition on RAM wiped during every reboot/poweroff
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = ["size=25%" "mode=755"];
    };

    # System disk
    disk.primary = {
      device = systemDisk;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          # EFI system partition for UEFI systems
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          # BTRFS partition
          btrfs = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                # Persisting "/nix" is mandatory
                "/nix" = {
                  mountpoint = "/nix";
                  inherit mountOptions;
                };

                # Persistent subvolume to store our persistent files/folders in
                "/persistent" = {
                  mountpoint = "/persistent";
                  inherit mountOptions;
                };
              };
            };
          };
        };
      };
    };
  };
}
