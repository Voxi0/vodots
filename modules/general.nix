{
  self,
  inputs,
  withSystem,
  ...
}: {
  # NixOS specific
  flake.modules.nixos.general = {
    config,
    pkgs,
    ...
  }: {
    # Use the configured `pkgs` instance from `perSystem`
    nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({pkgs, ...}: pkgs);

    # Nix
    nix = {
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

    # Security
    security.polkit = {
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

    # Services
    services = {
      # Power management
      upower.enable = true;
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

    # Use doas instead of sudo
    security = {
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [
          {
            users = ["${self.username}"];

            # Retain environment variables when running commands
            keepEnv = true;

            # Only require password authentication once
            persist = true;
          }
        ];
      };
    };

    # The first version of NixOS that was installed on this particular machine
    system.stateVersion = self.stateVersion;
  };

  # Home Manager specific
  flake.modules.homeManager.general = {
    imports = [inputs.nix-index-database.homeModules.default];

    # User information
    home = {
      inherit (self) username stateVersion;
      homeDirectory = "/home/${self.username}";
      keyboard.layout = self.kbLayout;
    };

    # Programs
    programs = {
      # Let Home Manager install and manage itself
      home-manager.enable = true;

      # Replace ccommand-not-found with nix-index for shell
      command-not-found.enable = false;
      nix-index.enable = true;

      # Lets you add a `,` before any command to automatically install required packages for the command to work
      # It's just a far more convenient version of plain old `nix-shell`
      nix-index-database.comma.enable = true;
    };

    # Automatically create XDG user directories
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };

    # Support for Linux distros other than NixOS
    targets.genericLinux = {
      enable = true;
      nixGL.vulkan.enable = true;
    };
  };
}
