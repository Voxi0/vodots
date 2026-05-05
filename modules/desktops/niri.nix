{
  self,
  ...
}: {
  flake.modules = {
    # NixOS specific
    nixos.niri = {pkgs, ...}: let
      system = pkgs.stdenv.hostPlatform.system;
      sddmTheme = pkgs.sddm-astronaut.override {
        embeddedTheme = "purple_leaves";
      };
    in {
      # Base packages
      environment.systemPackages = [sddmTheme];

      # Useful services
      services = {
        # For automounting drives and all
        udisks2.enable = true;

        # Allows changing system behavior based on user-selected power profiles
        power-profiles-daemon.enable = true;

        # Display manager / Login screen
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          extraPackages = [sddmTheme];
          theme = "sddm-astronaut-theme";
          settings = {
            Theme = {
              Current = "sddm-astronaut-theme";
            };
          };
        };
      };

      # XDG desktop portals allows apps to securely access resources outside it's sandbox
      # Required for screencasting, file pickers and other important stuff to work
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          # Implements most of the basic functionality
          xdg-desktop-portal-gtk

          # Required for screencasting support
          xdg-desktop-portal-gnome

          # Implements the secret portal which is required for some apps to work
          gnome-keyring
        ];
      };

      # Scrolling Wayland compositor
      programs.niri = {
        enable = true;
        package = self.packages.${system}.voniri;
      };
    };

    # Home Manager specific
    homeManager.niri = {pkgs, ...}: {
      # Frontend for udisks2 which allows you to manage removable drives easily
      services.udiskie.enable = true;

      # Base packages
      home.packages = with pkgs; [
        ############
        ### BASE ###
        ############
        wl-clipboard

        ###############
        ### THEMING ###
        ###############
        matugen
        pywalfox-native
        adw-gtk3
        bibata-cursors
        papirus-icon-theme

        ###########
        ### QT6 ###
        ###########
        kdePackages.qtsvg # For loading SVG images (bundled with most packages)
        kdePackages.qtimageformats # For WEBP images as well as some less common ones
        kdePackages.qtmultimedia # For playing videos, audio, etc
        kdePackages.qt5compat # Extra visual effects e.g. gaussian blur. MultiEffect is usually preferable
      ];
    };
  };

  flake.wrappers = {
    # Niri Wayland compositor
    voniri = {
      wlib,
      lib,
      pkgs,
      ...
    }: let
      system = pkgs.stdenv.hostPlatform.system;
      niriConfigDir = ../../config/niri;
    in {
      imports = [wlib.wrapperModules.niri];
      extraPackages = [pkgs.xwayland-satellite];
      "config.kdl".content = ''
        // General config - Environment variables and stuff
        ${builtins.readFile (niriConfigDir + "/config.kdl")}

        // Keybindings
        include "${niriConfigDir}/keybinds.kdl"

        // Autostart
        spawn-at-startup "${lib.getExe self.packages.${system}.voctalia-shell}"

        // Input config
        input {
          mod-key "Super"
          keyboard {
            numlock;
            xkb {
              layout "gb"

              // Remap the caps lock key into escape key
              // Very handy for Neovim
              options "caps:escape";
            }
          }
          touchpad {
            tap
            natural-scroll
          }
        }

        // Open the terminal emulator
        binds {
          Mod+Return hotkey-overlay-title="Launch the terminal emulator" repeat=false {
            spawn "${lib.getExe self.packages.${system}.vokitty}";
          }

          Mod+D hotkey-overlay-title="Open the app launcher" repeat=false {
            spawn "${lib.getExe self.packages.${system}.voctalia-shell}" "ipc" "call" "launcher" "toggle"
          }
        }
      '';
    };

    # Noctalia shell
    voctalia-shell = {wlib, ...}: {
      imports = [wlib.wrapperModules.noctalia-shell];
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };
  };
}