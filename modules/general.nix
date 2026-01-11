{
  self,
  withSystem,
  ...
}: {
  flake.modules = {
    # NixOS specific
    nixos.general = {
      config,
      pkgs,
      ...
    }: {
      # Use the configured pkgs from perSystem
      nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({pkgs, ...}: pkgs);

      # Nix
      nix = {
        optimise.automatic = true;
        settings = {
          trusted-users = ["root" "${self.username}"];
          experimental-features = ["nix-command" "flakes"];
          auto-optimise-store = true;
        };
      };

      # Boot
      console = {
        earlySetup = true;
        useXkbConfig = true;
        font = "Lat2-Terminus16";
      };
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # Internationalisation properties
      i18n.defaultLocale = self.locale;

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

      # Networking
      networking = {
        nftables.enable = true;
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
        };
      };

      # User
      users.users.${self.username} = {
        isNormalUser = true;
        initialPassword = "nixos";
        extraGroups = ["networkmanager" "wheel" "input"];
      };

      # Fonts
      fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];

      # The first version of NixOS that was installed on this particular machine
      # It's used to maintain compatibility with app data (e.g. databases) created on older NixOS versions
      # This shouldn't be changed after the initial install for any reason even when NixOS is updated
      # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
      system.stateVersion = "26.05";
    };

    # Home Manager specific
    homeManager.general = {pkgs, ...}: {
      programs.home-manager.enable = true;
      home = {
        inherit (self) username;
        homeDirectory = "/home/${self.username}";
        stateVersion = "26.05";
        packages = with pkgs;
          [
            obsidian
            slack
            helix
          ]
          ++ [self.inputs.NixNvim.packages.${pkgs.stdenv.system}.default];
      };

      # Automatically create XDG user directories e.g. 'Home', 'Downloads', 'Videos'
      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };

      # Move my wallpapers to installed system
      home.file."Pictures/Wallpapers" = {
        source = ../wallpapers;
        recursive = true;
      };
    };
  };
}
