{inputs, ...}: {
  flake.modules.homeManager = {
    floorp = {pkgs, ...}: {
      programs.floorp = {
        enable = true;
        languagePacks = ["en-US" "en-GB"];
        policies = {
          BlockAboutConfig = false;
        };
        profiles."vodots" = {
          isDefault = true;
          search.default = "ddg";
          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.system}; [
              ublock-origin
              darkreader
              disconnect
              gesturefy
            ];
          };
        };
      };
    };
  };
}
