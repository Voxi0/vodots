{self, ...}: {
  # NixOS specific
  flake.modules.nixos = {
    # Generic configuration to improve gaming experience
    gaming = {
      # Allows optimizations to be temporarily set for the host operating system and/or a game
      programs.gamemode.enable = true;
    };

    # Steam, do I even need to explain?
    steam = {pkgs, ...}: {
      programs.steam = {
        enable = true;

        # ProtonGE for running Windows games easily
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };

    # Sober Roblox client - Only available as a flatpak on flathub for the time being
    roblox = {
      # Ensure flatpaks are enabled and set up properly with `nix-flatpak` before attempting to install Sober
      imports = [self.modules.nixos.flatpak];
      services.flatpak.packages = ["com.vinegarhq.Sober"];
    };
  };

  # Home Manager specific
  flake.modules.homeManager = {
    # Simple game launcher for Steam, Epic, GOG etc
    # I use it primarily to run Windows games or whatever through Wine easily
    lutris = {pkgs, ...}: {
      programs.lutris = {
        enable = true;
        protonPackages = [ pkgs.proton-ge-bin ];
        extraPackages = with pkgs; [mangohud winetricks gamescope gamemode umu-launcher];
      };
    };
  };
}
