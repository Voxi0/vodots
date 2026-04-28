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

          # Use Betterfox
          preConfig = "${builtins.readFile ./user.js}";

          # Extensions
          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.system}; [
              ublock-origin # Very efficient ad-blocker
            ];
          };
        };
      };
    };
  };
}
