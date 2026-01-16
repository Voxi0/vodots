{
  flake.modules = {
    # NixOS specific
    nixos = {
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
    };

    # Home Manager specific
    homeManager = {
      # Sober is a Roblox player client only available as a Flatpak for now
      # It's basically a port of the Android client and claims to be more performant than a Windows Roblox client and all
      roblox = {
        services.flatpak = {
          enable = true;
          update.onActivation = true;
          packages = [
            {
              appId = "org.vinegarhq.Sober";
              origin = "flathub";
            }
          ];
        };
      };
    };
  };
}
