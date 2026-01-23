{inputs, ...}: {
  flake.modules = {
    # NixOS specific
    nixos.niri = {pkgs, ...}: let
      sddmTheme = pkgs.sddm-astronaut.override {
        embeddedTheme = "purple_leaves";
      };
    in {
      # Base packages
      environment.systemPackages = with pkgs; [
        ############
        ### BASE ###
        ############
        niri
        xwayland-satellite

        ###############
        ### THEMING ###
        ###############
        sddmTheme
        kdePackages.qtmultimedia
      ];

      # Useful services
      services = {
        # For automounting drives and all
        udisks2.enable = true;

        # Display manager / Login screen
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          extraPackages = with pkgs; [sddmTheme];
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

      # Enable things instead of just installing whenever possible
      programs = {
        # Desktop shell to transform your Wayland compositor to a fully blown desktop environment
        dank-material-shell = {
          enable = true;
          systemd.enable = true;
          quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
          dgop.package = pkgs.dgop;
          enableSystemMonitoring = true;
          enableDynamicTheming = true;
          enableClipboardPaste = true;
          enableAudioWavelength = true;
          enableVPN = true;
          enableCalendarEvents = false;
          plugins = {
            dankBatteryAlerts.enable = true;
            easyEffects.enable = true;
            displaySettings.enable = true;
            nixMonitor.enable = true;
            tailscale.enable = true;
          };
        };
      };
    };

    # Home Manager specific
    homeManager.niri = {};
  };
}
