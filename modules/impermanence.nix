{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos = {
    impermanence = {lib, ...}: {
      imports = [inputs.preservation.nixosModules.default];

      # `systemd-machine-id-commit.service` will fail but it isn't relevant in this setup for a persistent machine-id so just disable it
      systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

      # Set up impermanence
      preservation = {
        enable = true;
        preserveAt."/persist" = {
          # Preserve system files/folders
          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
            }
          ];
          directories = [
            {
              directory = "/var/lib/nixos";
              inInitrd = true;
            }
            "/var/lib/bluetooth"
            "/var/lib/power-profiles-daemon"
          ];

          # Preserve user files/folders
          users.${self.username} = {
            files = [
              ".gitconfig"
              ".wakatime.cfg"
              ".steampath"
              ".steampid"
            ];
            directories = [
              "Desktop"
              "Pictures"
              "Documents"
              "Downloads"
              "Music"
              "Videos"

              ".local"
              ".steam"
              ".var/app"
              ".wakatime"
            ];
          };
        };
      };
    };
  };
}
