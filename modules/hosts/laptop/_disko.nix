let
  systemDrive = "/dev/sda";
  mountOptions = ["noatime" "compress=zstd" "discard=async"];
in {
  # Ensure system doesn't boot before "/nix" is mounted
  fileSystems."/nix".neededForBoot = true;

  # Disk layout
  disko.devices = {
    # Store the entire root directory on RAM
    # So everything gets wiped on every reboot/poweroff whatever
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        # Maximum amount of RAM the root directory can use
        "size=25%"
        "mode=755"
      ];
    };

    # Main/primary disk
    disk.main = {
      device = systemDrive;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };

          esp = {
            name = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          root = {
            name = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/nix" = {
                  inherit mountOptions;
                  mountpoint = "/nix";
                };
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