{
  self,
  withSystem,
  inputs,
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
        package = pkgs.lixPackageSets.stable.lix;
        optimise.automatic = true;
        settings = {
          trusted-users = ["root" "${self.username}"];
          experimental-features = ["nix-command" "flakes"];
          auto-optimise-store = true;
          extra-substituters = ["https://noctalia.cachix.org"];
          extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
        };
      };

      # Boot
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
        kernelModules = ["i2c-dev" "ddcci_backlight"];
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

      # Required for DDCCI backlight driver to work
      hardware.i2c.enable = true;
      services.ddccontrol.enable = true;

      # Internationalisation properties
      i18n.defaultLocale = self.locale;

      # Networking
      networking = {
        nftables.enable = true;
        firewall.enable = true;
        dhcpcd.enable = false;
        networkmanager = {
          enable = true;
          wifi.backend = "iwd";
        };
      };

      # User
      users.users.${self.username} = {
        isNormalUser = true;
        initialPassword = "nixos";
        extraGroups = ["networkmanager" "wheel" "input" "cdrom" "kvm"];
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
    homeManager.general = {
      imports = [inputs.nix-index-database.homeModules.default];

      # Set user information
      home = {
        # Home Manager
        inherit (self) username;
        homeDirectory = "/home/${self.username}";
        stateVersion = "26.05";

        # Keyboard
        keyboard.layout = self.kbLayout;
      };

      # Programs
      programs = {
        # Let Home Manager install and manage itself
        home-manager.enable = true;

        # Replace ccommand-not-found with nix-index for shell
        command-not-found.enable = false;
        nix-index.enable = true;

        # Lets you add a `,` before any command to automatically install required packages for the command
        # It's just a far more convenient version of plain old `nix-shell`
        nix-index-database.comma.enable = true;
      };

      # Automatically create XDG user directories e.g. 'Home', 'Downloads', 'Videos'
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };

      # Better support Linux distros other than NixOS
      targets.genericLinux = {
        enable = true;
        nixGL.vulkan.enable = true;
      };
    };
  };
}