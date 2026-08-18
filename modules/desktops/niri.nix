{self, ...}: {
  # NixOS specific
  flake.modules.nixos.niri = {pkgs, ...}: let
    sddmTheme = pkgs.sddm-astronaut.override {embeddedTheme = "purple_leaves";};
  in {
    # Install SDDM theme
    environment.systemPackages = [sddmTheme];

    # Services
    services = {
      # For automounting removable drives
      udisks2.enable = true;

      # Allows changing system behaviour based on user-selected power profiles
      power-profiles-daemon.enable = true;

      # Display manager / Login screen
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        extraPackages = [sddmTheme];
        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {Current = "sddm-astronaut-theme";};
        };
      };
    };

    # XDG desktop portal
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk # Implements most of the basic functionality
        xdg-desktop-portal-gnome # Required for screencasting support
        gnome-keyring # Implements the secret portal required by some apps
      ];
    };

    # Niri - A scrollable tiling Wayland compositor
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.voniri;
    };
  };

  # Home Manager specific
  flake.modules.homeManager.niri = {pkgs, ...}: {
    services = {
      # Frontend for Udisks2 to manage removable drives easily
      udiskie.enable = true;
    };

    # Base packages
    home.packages = with pkgs;
      [
        wl-clipboard

        # Theming
        matugen
        pywalfox-native
        adw-gtk3
        bibata-cursors
        papirus-icon-theme
      ]
      ++
      # QT6 - Mainly required for SDDM theme
      (with kdePackages; [
        qtsvg # For loading SVG images (bundled with most packages)
        qtimageformats # For WEBP images as well as some less common ones
        qtmultimedia # For playing videos, audio, etc
        qt5compat # Extra visual effects e.g. gaussian blur. MultiEffect is usually preferable
      ]);
  };
}
