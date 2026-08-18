{inputs, ...}: {
  flake.modules.homeManager.floorp = {pkgs, ...}: {
    programs.floorp = {
      enable = true;
      languagePacks = ["en-US" "en-GB"];
      policies.BlockAboutConfig = false;

      profiles."Vodots" = {
        isDefault = true;
        search = {
          default = "ddg";
          privateDefault = "ddg";
        };

        # Use Betterfox
        preConfig = let
          src = pkgs.fetchFromGitHub {
            owner = "yokoffing";
            repo = "Betterfox";
            rev = "8e415d1633f10fe0192d9c938e4ca2628eeec9f9";
            hash = "sha256-nLkaxpbAMifWxx/RJvuaDpjndzKFPTvAO8o9gR47HtU=";
          };
        in
          builtins.readFile "${src}/Fastfox.js";

        # Just some settings
        settings = {
          # Don't hide the tab bar when fullscreen
          "browser.fullscreen.autohide" = false;

          # Stop the alt key from toggling some menu
          "ui.key.menuAccessKeyFocuses" = false;
        };

        # Extensions
        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin # Very efficient ad-blocker
          ];
        };
      };
    };
  };
}
