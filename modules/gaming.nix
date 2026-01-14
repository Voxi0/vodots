{
  # NixOS specific
  flake.modules.nixos = {
    # General gaming stuff that you probably want for the best experience and performance and all
    gaming = {
      # Enable udev rules for the Steam Controller, other supported controllers and the HTC Vive
      hardware.steam-hardware.enable = true;

      # Configure Steam and other stuff to improve game performance
      programs = {
        gamemode.enable = true;
        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };
    };

    # Steam with ProtonGE compatibility layer
    steam = {pkgs, ...}: {
      programs.steam = {
        enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };

    # Sober is the Roblox player client or whatever, only available as a Flatpak for now
    roblox = {
      services.flatpak = {
        enable = true;
        update.auto.enable = false;
        packages = [
          {
            appId = "org.vinegarhq.Sober";
            origin = "flathub";
          }
        ];
      };
    };
  };

  # Home Manager specific
  flake.modules.homeManager = {
    minecraft = {pkgs, ...}: {
      home.packages = [
        (pkgs.prismlauncher.override {
          jdks = [pkgs.graalvmPackages.graalvm-ce];
        })
      ];
    };
  };
}
