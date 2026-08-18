{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos = {
    impermanence = {lib, ...}: {
      imports = [inputs.preservation.nixosModules.default];

      # Clean temporary files on boot duh
      boot.tmp.cleanOnBoot = true;

      # `systemd-machine-id-commit.service` will fail but it isn't relevant in this setup for a persistent machine-id so just disable it
      systemd = {
        suppressedSystemUnits = ["systemd-machine-id-commit.service"];
        tmpfiles.settings.preservation."/persistent/home/${self.username}".d.mode = lib.mkForce "700";
      };

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

            # Secure boot keys
            "/var/lib/sbctl/"

            # Timesync data and backlight levels
            "/var/lib/systemd/"

            # Saved bluetooth and internet connections
            "/var/lib/bluetooth/"
            "/var/lib/iwd/"
            "/var/lib/NetworkManager/"
            "/etc/NetworkManager/system-connections/"

            # Current power profile state and all
            "/var/lib/power-profiles-daemon/"

            # Tailscale
            "/var/lib/tailscale/"

            # Logs obviously
            "/var/log/"

            # Flatpak applications
            "/var/lib/flatpak/"

            # SSH host keys
            "/etc/ssh/"

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
              ".config/gtk-3.0/settings.ini"
              ".icons/default/index.theme"
              ".config/xsettingsd/xsettingsd.conf"
            ];
            directories = [
              # User home XDG directories
              "Desktop/"
              "Documents/"
              "Pictures/"
              "Downloads/"
              "Music/"
              "Videos/"
              "Games/"

              # Steam games and other application state etc
              ".local/"

              # SSH keys and all duh
              ".ssh/"

              # Noctalia and it's generated color palettes and such
              ".cache/noctalia/"
              ".cache/wal/"

              # Spotify
              ".cache/spotify/"

              # Theming
              ".config/dconf/"
              ".config/gtk-4.0/"

              # OBS Studio
              ".config/obs-studio/"

              # Games
              {
                directory = ".steam/root/";
                how = "symlink";
              }
              {
                directory = ".steam/steam/";
                how = "symlink";
              }

              # Flatpak applications and a whole lotta other stuff
              ".var/"

              # Browser and Wakatime
              ".wakatime/"
              ".floorp/"
              ".mozilla/"

              # Discord
              ".config/equibop/"
              ".config/goofcord/"
            ];
          };
        };
      };
    };
  };
}
