{
  self,
  inputs,
  ...
}: {
  # NixOS specific
  flake.modules.nixos.mangowm = {pkgs, ...}: {
    services = {
      # Daemon, tools and libraries to access and manage storage devices
      # Used by `udiskie` for automounting removable drives and such
      udisks2.enable = true;
    };

    # Mango Wayland compositor
    imports = [inputs.mangowm.nixosModules.mango];
    programs.mango = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.vongowm;
    };

    # Import Home Manager specific module
    home-manager.users.${self.username}.imports = [self.modules.homeManager.mangowm];
  };

  # Home Manager specific
  flake.modules.homeManager.mangowm = {pkgs, ...}: {
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
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config.common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Inhibit" = ["none"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
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
        nwg-look # Theme settings setter or whatever
        qt6.qtwayland # QT Wayland support
        adw-gtk3 # GTK theme
        bibata-cursors
        papirus-icon-theme
      ]
      ++ [self.packages.${pkgs.stdenv.hostPlatform.system}.vokitty];
  };
}
