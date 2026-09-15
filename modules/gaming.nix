{
  # NixOS specific
  flake.modules.nixos = {
    gaming = {
      # Allows optimizations to be temporarily set for the host operating system and/or a game
      programs.gamemode.enable = true;
    };

    steam = {pkgs, ...}: {
      programs.steam = {
        enable = true;

        # ProtonGE for running Windows games easily
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };
  };

  # Home Manager specific
  flake.modules.homeManager = {
    lutris = {pkgs, ...}: {
      programs.lutris = {
        enable = true;
        protonPackages = [ pkgs.proton-ge-bin ];
        extraPackages = with pkgs; [mangohud winetricks gamescope gamemode umu-launcher];
      };
    };
  };
}
