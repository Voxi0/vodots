{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos = {
    impermanence = {
      imports = [inputs.preservation.nixosModules.default];

      # `systemd-machine-id-commit.service` will fail but it isn't relevant in this setup for a persistent machine-id so just disable it
      systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

      # Clean temporary files on boot duh
      boot.tmp.cleanOnBoot = true;

      # Set up impermanence
      preservation = {
        enable = true;
        preserveAt."/persistent" = {
          # Preserve system files/folders
          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
            }
          ];
          directories = [
            # Users and group state
            "/var/lib/nixos/"

            # Timesync data and backlight levels
            "/var/lib/systemd"

            # Saved bluetooth and internet connections
            "/var/lib/bluetooth/"
            "/etc/NetworkManager/system-connections/"

             # Current power profile state and all
            "/var/lib/power-profiles-daemon"

            # SSH host keys
            "/etc/ssh"

            # Logs obviously
            "/var/log/"

            # Flatpak applications
            "/var/lib/flatpak/"

            # Used extensively by many programs and all
            # So we persist it to ensure our tmpfs doesn't get filled up
            {
              directory = "/tmp/";
              mode = "1777";
              user = "root";
              group = "root";
            }
          ];

          # Preserve user files/folders
          users.${self.username} = {
            files = [
              ".wakatime.cfg"

              # Theming
              ".gtkrc-2.0"

              # Git configuration
              # We can't persist '.gitconfig' because of how 'git config' works so this is a workaround
              ".config/git/config"
            ];
            directories = [
              # User home XDG directories
              "Desktop/" "Documents/" "Pictures/" "Downloads/" "Music/" "Videos/"

              # Steam games and other application state etc
              ".local/"

              # SSH keys and all duh
              ".ssh/"

              # Theming
              ".icons/"
              ".config/gtk-3.0/"
              ".config/gtk-4.0/"
              ".config/xsettingsd/"

              # Steam
              ".steam/"

              # Flatpak applications and a whole lotta other stuff
              ".var/"

              # Browser and Wakatime
              ".wakatime/"
              ".floorp/"
              ".mozilla/"

              # Noctalia and it's generated color palettes and such
              ".cache/noctalia/"
              ".cache/wal/"
            ];
          };
        };
      };
    };
  };
}