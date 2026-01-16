{inputs, ...}: {
  flake.modules.homeManager.spotify = {pkgs, ...}: {
    # Tool to customize the Spotify client
    spicetify = {
      enable = true;
      wayland = true;
      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.extensions; [
        adblock # Removes ads
        powerBar # Search bar similar to MacOS Spotlight
        groupSession # Lets you create a shareable link to let others listen along with you
        autoSkipVideo # Disable videos because some regions can't play videos
      ];
    };
  };
}
