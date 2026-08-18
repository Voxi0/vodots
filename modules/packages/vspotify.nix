{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.vspotify = inputs.spicetify-nix.lib.mkSpicetify pkgs (let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      theme = spicePkgs.themes.starryNight;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        spicyLyrics
      ];
    });
  };
}
