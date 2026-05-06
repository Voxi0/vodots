{self, ...}: let
  hostname = "laptop";
  modules = with self.modules.nixos; [
    # Base
    general
    openTabletDriver
    niri
    fish

    # Services
    fwupd
    power-profiles-daemon
    audio
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
    # Base
    general
    easyeffects
    niri

    # Apps
    cli
    fish
    neovim
    fastfetch
    yazi
    floorp
    helium
    vscode
    spotify
    discord
    obs-studio
  ];
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname modules hmModules;};
    modules = {
      # NixOS specific
      nixos.${hostname} = {pkgs, ...}: {
        # Boot
        console = {
          earlySetup = true;
          useXkbConfig = true;
          font = "Lat2-Terminus16";
        };

        # Security
        security = {
          rtkit.enable = true;
          polkit = {
            enable = true;

            # Some extra stuff to allow unprivileged users to reboot/poweroff
            extraConfig = ''
              polkit.addRule(function (action, subject) {
                if (
                  subject.isInGroup("users") &&
                  [
                    "org.freedesktop.login1.reboot",
                    "org.freedesktop.login1.reboot-multiple-sessions",
                    "org.freedesktop.login1.power-off",
                    "org.freedesktop.login1.power-off-multiple-sessions",
                  ].indexOf(action.id) !== -1
                ) {
                  return polkit.Result.YES;
                }
              });
            '';
          };
        };

        # Fonts
        fonts.packages = with pkgs.nerd-fonts; [jetbrains-mono iosevka];

        # Disk burner
        programs.k3b.enable = true;
      };

      # Home Manager specific
      homeManager.${hostname} = {pkgs, ...}: {
        # Some extra apps/games for me
        home = {
          # Environment variables to be set at login
          sessionVariables = {
            EDITOR = "nvim";
            MANPAGER = "nvim +Man!";
          };

          # Some apps and all only for this host
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

              # Minecraft launcher
              (pkgs.prismlauncher.override {
                jdks = [pkgs.graalvmPackages.graalvm-ce];
              })
            ]
            ++ [self.packages.${pkgs.stdenv.hostPlatform.system}.voctalia-shell];

          # Move my wallpapers to installed system
          file."Pictures/Wallpapers" = {
            source = ../../../wallpapers;
            recursive = true;
          };
        };
      };
    };
  };
}
