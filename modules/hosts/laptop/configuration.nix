{self, ...}: let
  hostname = "laptop";
  nixosModules = with self.modules.nixos; [
    preservation
    intel-graphics
    # nvidia-graphics
    pipewire
    fish
    # mangowm
    niri
    bluetooth
    yubikey
    openTabletDriver
    # gaming
    # steam
    # roblox
  ];
  hmModules = with self.modules.homeManager; [
    cli
    neovim
    floorp
    discord
    # lutris
    # obs-studio
  ];
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname nixosModules hmModules;};

    # NixOS specific
    modules.nixos.${hostname} = {pkgs, ...}: {
      services = {
        # Display/Login manager
        displayManager.noctalia-greeter = {
          enable = true;
          settings = {
            keyboard = {
              layout = self.kbLayout;
              options = "caps_lock:escape";
              numlock = true;
            };
          };
        };

        # Mesh VPN
        tailscale.enable = true;
      };

      # Power-saving stuff
      networking.networkmanager.wifi.powersave = true;

      # Fonts
      fonts.packages = with pkgs.nerd-fonts; [iosevka];
    };

    # Home Manager specific
    modules.homeManager.${hostname} = {pkgs, ...}: {
      home.packages = with pkgs; [
        # Git
        git
        lazygit # TUI for Github

        # For working with Github directly from the CLI
        gh
        gh-dash # TUI for gh

        obsidian # Note taking
        ferdium # Keep a bunch of different communication services in one place
        feishin # Audio player
        uzdoom # DOOM

        # Halloy (IRC) and Gajim (XMPP) client
        halloy
        gajim
      ];
    };
  };
}
