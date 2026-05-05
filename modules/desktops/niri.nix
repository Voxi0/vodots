{
  self,
  inputs,
  ...
}: {
  flake.modules = {
    # NixOS specific
    nixos.niri = {pkgs, ...}: let
      sddmTheme = pkgs.sddm-astronaut.override {
        embeddedTheme = "purple_leaves";
      };
    in {
      imports = [inputs.noctalia.nixosModules.default];

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

        # Desktop shell to transform your Wayland compositor to a fully blown desktop environment
        noctalia-shell = {
          enable = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.voctalia-shell;
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
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.voniri;
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
      niriConfigDir = ../../config/niri;
    in {
      imports = [wlib.wrapperModules.niri];
      "config.kdl".content = ''
        // General config - Environment variables and stuff
        ${builtins.readFile (niriConfigDir + "/config.kdl")}

        // Keybindings and stuff
        include "${niriConfigDir}/input.kdl"
      '';
      settings = {
        input.keyboard = {
          xkb.layout = "uk";
        };

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
        };
      };
    };

    # Noctalia shell
    voctalia-shell = {wlib, ...}: {
      imports = [wlib.wrapperModules.noctalia-shell];
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };
  };
}
