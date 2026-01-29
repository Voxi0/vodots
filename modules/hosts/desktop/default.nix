{self, ...}: let
  hostname = "desktop";
  modules = with self.modules.nixos;
    [
      # Base
      general
      niri
      fish

      # Services
      audio
      tailscale
      ssh
      yubikey

      # Gaming
      gaming
      steam
      roblox
    ]
    ++ (with self.inputs; [
      dms.nixosModules.dank-material-shell
      dms-plugin-registry.modules.default
    ]);
  hmModules = with self.modules.homeManager;
    [
      # Base
      general
      niri

      # Apps
      cli
      fastfetch
      yazi
      firefox
      spotify
      discord
      obs-studio
    ]
    ++ (with self.inputs; [
      dms.homeModules.dank-material-shell
      nix-flatpak.homeManagerModules.nix-flatpak
      nvdots.homeModule
      spicetify-nix.homeManagerModules.spicetify
      nixcord.homeModules.nixcord
    ]);
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
        fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
      };

      # Home Manager specific
      homeManager.${hostname} = {pkgs, ...}: {
        # Some extra apps/games for me
        home = {
          # Environment variables to be set at login
          sessionVariables = {
            TERMINAL = "kitty";
            EDITOR = "nvim";
          };

          # Some apps and all only for this host
          packages = with pkgs; [
            kitty
            git
            lazygit
            thunar
            mpv
            obsidian
            slack
            halloy
            (pkgs.prismlauncher.override {
              jdks = [pkgs.graalvmPackages.graalvm-ce];
            })
          ];

          # Move my wallpapers to installed system
          file."Pictures/Wallpapers" = {
            source = ../../../wallpapers;
            recursive = true;
          };
        };

        # Add extra plugins and Lua configuration to my Neovim config
        nvdots = {
          enable = true;
          packageNames = ["nvdots"];
          categoryDefinitions.merge = {...}: {
            # Add Wakatime plugin
            lspsAndRuntimeDeps.general.deps = [pkgs.wakatime-cli];
            optionalPlugins.general.misc = [pkgs.vimPlugins.vim-wakatime];
            optionalLuaAdditions.general = [
              "vim.cmd.packadd('vim-wakatime')"
            ];
          };
        };
      };
    };
  };
}
