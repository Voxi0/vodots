{inputs, ...}: {
  flake.modules.nixos = {
    gaming = {
      # Enable udev rules for the Steam Controller, other supported controllers and the HTC Vive
      hardware.steam-hardware.enable = true;

      # Programs to optimize gaming performance
      programs = {
        # Optimizes system performance for gaming by temporarily applying various enhancements
        # Such as adjusting CPU governor settings, prioritizing I/O, and inhibiting the screensaver
        gamemode.enable = true;

        # Micro-compositor for gaming developed by Steam
        # Improves performance by wrapping games in an isolated environment
        # Allows features like FSR upscaling, precise FPS limiting, and lower latency
        gamescope = {
          enable = true;
          capSysNice = true;
        };
      };
    };

    steam = {pkgs, ...}: {
      programs.steam = {
        enable = true;

        # For playing Windows games
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };

    # Sober is a Roblox player client only available as a Flatpak for now
    roblox = {
      imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
      services.flatpak = {
        enable = true;
        update.onActivation = true;
        packages = ["org.vinegarhq.Sober"];
      };
    };
  };

  flake.modules.homeManager = {
    # Game manager convenient for running emulated and Windows games
    lutris = {pkgs, ...}: {
      programs.lutris = {
        enable = true;

        # For playing Windows games
        protonPackages = [pkgs.proton-ge-bin];
      };
    };
  };
}
