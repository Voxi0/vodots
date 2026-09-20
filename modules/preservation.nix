{self, inputs, ...}: {
  flake.modules.nixos.preservation = {lib, ...}: {
    imports = [inputs.preservation.nixosModules.default];

    # Clean temporary files on boot to get rid of clutter
    boot.tmp.cleanOnBoot = true;

    # `systemd-machine-id-commit.service` would fail but it isn't relevant in this setup for a persistent machine-id so we disable it
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

    # Define what files and folders to keep persistent on drive
    preservation = {
      enable = true;
      preserveAt."/persistent" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
        directories = [
          # Temporary files
          {
            directory = "/tmp";
            mode = "1777";
            user = "root";
            group = "root";
          }

          # Users and group state
          {
            directory = "/var/lib/nixos";
            # inInitrd = true;
          }

          "/var/lib/systemd/" # Timesync data and backlight levels
          "/var/lib/fwupd/" # Firwmare update manager
          "/var/lib/systemd/" # Timesync data and backlight levels
          "/var/lib/tailscale/" # Tailscale
          "/var/lib/flatpak/" # Flatpak applications

          # Saved bluetooth and internet connections
          "/var/lib/bluetooth/"
          "/var/lib/iwd/"
          "/etc/NetworkManager/system-connections/"
        ];

        users.${self.username} = {
          files = [
            # Wakatime for Hackclub
            ".wakatime.cfg"

            # Currently set theme and icon settings
            ".gtkrc-2.0"
            ".config/xsettingsd/xsettingsd.conf"
            ".config/gtk-3.0/settings.ini"
            ".icons/default/index.theme"

            # UZDoom settings
            ".config/uzdoom/uzdoom.ini"
          ];
          directories = [
            # User home directories
            "Desktop/"
            "Downloads/"
            "Documents/"
            "Pictures/"
            "Music/"
            "Videos/"
            "Games/"

            ".ssh/" # User SSH keys
            ".var/" # Flatpak applications and a whole lotta other stuff
            ".local/" # Application state and such etc
            # ".local/share/zoxide/" # Zoxide database
            # ".local/state/noctalia/" # Noctalia
            # ".local/state/wireplumber"
            # ".local/share/flatpak/" # User specific configuration for flatpaks

            # Theming
            ".config/nwg-look/"
            ".config/dconf/"
            ".config/gtk-4.0/"

            # Applications that aren't managed by Home Manager
            ".config/gajim/"
            ".config/halloy/"
            ".config/lazygit/"
            ".config/feishin/"
            ".config/obs-studio/"
            ".config/obsidian/"
            ".config/legcord/"
            ".config/git/"
            ".config/gh/"

            # Cache
            ".cache/spotify/" # So we don't have to log back into Spotify everytime

            # Floorp
            ".mozilla/" # Required mainly for Pywalfox to keep working flawlessly
            ".floorp/"

            # Games
            {
              directory = ".steam/root/";
              how = "symlink";
            }
            {
              directory = ".steam/steam/";
              how = "symlink";
            }
          ];
        };
      };
    };
  };
}
