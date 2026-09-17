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
    # Set `nixpkgs` instance
    nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({pkgs, ...}: pkgs);

    # Nix settings
    nix.settings = {
      trusted-users = ["root" "${self.username}"];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    # Hardware
    hardware = {
      enableAllFirmware = true;
      enableAllHardware = true;
      system76.enableAll = true;
    };

    # Boot
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    # Networking
    networking = {
      firewall.enable = true;
      nftables.enable = true;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
    };

    # Timezone, locale and Xserver keyboard layout
    time.timeZone = self.timezone;
    i18n.defaultLocale = self.locale;
    services.xserver.xkb.layout = self.kbLayout;

    # Users
    users.users.${self.username} = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = ["wheel" "networkmanager"];
    };

    # Firmware update manager
    services.fwupd.enable = true;

    # State version
    system.stateVersion = self.stateVersion;
  };

  # Home Manager specific
  flake.modules.homeManager.general = {
    home = {
      # User information
      inherit (self) username stateVersion;
      homeDirectory = "/home/${self.username}";
      keyboard.layout = self.kbLayout;

      # Move my wallpapers to system
      file."Pictures/Wallpapers" = {
        source = ../wallpapers;
        recursive = true;
      };

      # Globally enable shell integration for all supported shells
      shell.enableShellIntegration = true;
    };

    # Allow Home Manager to install and manage itself
    programs.home-manager.enable = true;

    # Enable and use user XDG directories
    home.preferXdgDirectories = true;
    xdg.userDirs.enable = true;

    # Settings that makes Home Manager work better on GNU/Linux distributions other than NixOS
    targets.genericLinux = {
      enable = true;
      gpu.enable = true;
    };
  };
}
