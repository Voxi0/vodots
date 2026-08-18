{self, ...}: let
  hostname = "laptop";
  nixosModules = with self.modules.nixos; [
    general
    impermanence
    openTabletDriver
    niri
    fish

    # Services
    fwupd
    power-profiles-daemon
    pipewire
    tailscale
    ssh
    yubikey

    # Gaming
    gaming
    steam
    roblox

    # Virtualisation
    virt-manager
  ];
  hmModules = with self.modules.homeManager; [
    general
    niri

    # Apps
    cli
    fish
    neovim
    fastfetch
    yazi
    floorp
    discord
    obs-studio
  ];
in {
  flake = {
    # Create a NixOS configuration/host
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname nixosModules hmModules;};

    # Extra host specific configuration
    modules.nixos.${hostname} = {pkgs, ...}: {
      # Disk burner
      programs.k3b.enable = true;

      # Extra fonts
      fonts.packages = with pkgs.nerd-fonts; [jetbrains-mono iosevka];
    };

    modules.homeManager.${hostname} = {pkgs, ...}: {
      home = {
        # Move my wallpapers to system
        file."Pictures/Wallpapers" = {
          source = ../../../wallpapers;
          recursive = true;
        };

        # Extra apps for this host
        packages = with pkgs;
          [
            # Version control system
            git
            lazygit

            # File explorer
            thunar
            tumbler # Required for thumbnails

            # Media players
            mpv # Videos
            feishin # Audio

            # Note taking
            obsidian

            # Just for Hackclub
            slack

            # IRC client
            halloy
          ]
          ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
            # Spotify
            vspotify

            # Noctalia shell
            voctalia-shell
          ]);
      };
    };
  };
}
