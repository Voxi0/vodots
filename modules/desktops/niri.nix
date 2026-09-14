{
  self,
  ...
}: {
  # NixOS specific
  flake.modules.nixos.niri = {pkgs, ...}: {
    services = {
      # Daemon, tools and libraries to access and manage storage devices
      # Used by `udiskie` for automounting removable drives and such
      udisks2.enable = true;
    };

    # Niri - A scrollable tiling Wayland compositor
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.voniri;
    };

    # Import Home Manager specific module
    home-manager.users.${self.username}.imports = [self.modules.homeManager.niri];
  };

  # Home Manager specific
  flake.modules.homeManager.niri = {pkgs, ...}: {
    services = {
      udiskie.enable = true; # Automounter for removable media using `udisks2`
      mpris-proxy.enable = true; # Bluetooth headset buttons to control media player
      awww.enable = true; # Efficient animated wallpaper daemon
      blueman-applet.enable = true; # Bluetooth manager applet
      gnome-keyring.enable = true; # For storing passwords/secrets
    };

    # Desktop portal - Handles a lot of stuff for your desktop e.g. file pickers, screensharing, etc.
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk # Implements most of the basic functionality
        xdg-desktop-portal-gnome # Required for screencasting support
      ];
      config.common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Inhibit" = ["none"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };
    };

    # Packages
    home.packages = with pkgs;
      [
        # Base
        noctalia # Desktop shell
        wl-clipboard # Clipboard manager
        pavucontrol # Audio/Volume control

        # Theming
        pywalfox-native
        matugen
        nwg-look # Theme settings setter or whatever
        qt6.qtwayland # QT Wayland support
        adw-gtk3 # GTK theme
        bibata-cursors
        papirus-icon-theme

        evtest
      ]
      ++ [self.packages.${pkgs.stdenv.hostPlatform.system}.vokitty];
  };
}
