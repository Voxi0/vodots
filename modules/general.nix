{
  self,
  withSystem,
  ...
}: {
  # NixOS specific
  flake.modules.nixos.general = {
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
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    # Internationalisation properties
    i18n.defaultLocale = self.locale;

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

    # Programs
    programs = {
      # Nix CLI helper
      nh.enable = true;

      # SUID wrapper
      mtr.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    # The first version of NixOS that was installed on this particular machine
    # It's used to maintain compatibility with app data (e.g. databases) created on older NixOS versions
    # This shouldn't be changed after the initial install for any reason even when NixOS is updated
    # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
    system.stateVersion = "26.05";
  };

  # Home Manager specific
  flake.modules.homeManager.general = {
    programs.home-manager.enable = true;
    home = {
      inherit (self) username;
      homeDirectory = "/home/${self.username}";
      stateVersion = "26.05";
    };

    # Automatically create XDG user directories e.g. 'Home', 'Downloads', 'Videos'
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
