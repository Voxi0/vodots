{self, ...}: let
  hostname = "desktop";
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
    lutris
  ];
in {
  flake = {
    # Create a NixOS configuration/host
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname nixosModules hmModules;};

    # Extra host specific configuration
    modules.nixos.${hostname} = {
      lib,
      config,
      pkgs,
      ...
    }: {
      # NVidia specific stuff
      boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
      services.xserver.videoDrivers = ["nvidia"];
      hardware.nvidia = {
        # Wayland requires kernel mode setting (KMS) to be enabled (Highly Recommended)
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = true;

        # Use proprietary drivers since they usually offer better performance
        open = false;
      };

      # Swap
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      # Extra fonts
      fonts.packages = with pkgs.nerd-fonts; [
        jetbrains-mono
        iosevka
      ];
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
            git # Version Control System (VCS)
            lazygit # Awesome TUI for Git
            thunar # File explorer
            tumbler # Required by Thunar for thumbnails
            mpv # Video player
            feishin # Audio player
            obsidian # Note taking
            slack # Just for Hackclub
            halloy # IRC client
            ferdium # Keep all communication services or whatever in one place
            # celeste # File synchronization client that works with any cloud provider

            # Minecraft
            (pkgs.prismlauncher.override {
              jdks = [pkgs.graalvmPackages.graalvm-ce];
            })
          ]
          ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
            vspotify # Spotify with Spicetify
            voctalia-shell # Noctalia desktop shell
          ]);
      };
    };
  };
}
