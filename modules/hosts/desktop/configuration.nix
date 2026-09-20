{self, ...}: let
  hostname = "desktop";
  nixosModules = with self.modules.nixos; [
    preservation
    nvidia-graphics
    pipewire
    fish
    # mangowm
    niri
    bluetooth
    yubikey
    openTabletDriver
    gaming
    steam
    roblox
  ];
  hmModules = with self.modules.homeManager; [
    cli
    neovim
    git
    github
    floorp
    discord
    lutris
    obs-studio
  ];
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname nixosModules hmModules;};

    # NixOS specific
    modules.nixos.${hostname} = {pkgs, ...}: let
      sddmTheme = pkgs.sddm-astronaut.override {embeddedTheme = "pixel_sakura";};
    in {
      services = {
        # Display/Login manager
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          theme = "sddm-astronaut-theme";
          settings.Theme.Current = "sddm-astronaut-theme";
          extraPackages = [
            pkgs.kdePackages.qtmultimedia # Required for video backgrounds/audio
          ];
        };

        # Mesh VPN
        tailscale.enable = true;
      };

      # System-wide installed packages
      environment.systemPackages = with pkgs.qt6;
        [
          # QT6
          qtbase
          qtsvg
          qtvirtualkeyboard
          qtmultimedia
        ]
        ++ [
          # We need the SDDM theme installed or else it won't work for some reason
          sddmTheme
        ];

      # Compressed block device on RAM used as a swap device
      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };

      # Fonts
      fonts.packages = with pkgs.nerd-fonts; [iosevka];
    };

    # Home Manager specific
    modules.homeManager.${hostname} = {pkgs, ...}: {
      home.packages = with pkgs; [
        obsidian # Note taking
        ferdium # Keep a bunch of different communication services in one place
        feishin # Audio player
        uzdoom # DOOM

        # Minecraft
        (pkgs.prismlauncher.override {
          jdks = with pkgs; [
            jdk25
            graalvmPackages.graalvm-ce
          ];
        })

        # Halloy (IRC) and Gajim (XMPP) client
        halloy
        gajim
      ];
    };
  };
}
