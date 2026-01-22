{
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
    };

    # Home Manager specific
    homeManager.niri = {pkgs, ...}: {
      # Authentication agent - Just provides a GUI for authentication
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Install = {
          WantedBy = ["graphical-session.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
