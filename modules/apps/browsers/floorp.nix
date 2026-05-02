{inputs, ...}: {
  flake.modules.homeManager = {
    floorp = {pkgs, ...}: {
      programs.floorp = {
        enable = true;
        languagePacks = ["en-US" "en-GB"];
        policies = {
          BlockAboutConfig = false;
        };

        # Extensions and `about:config` settings and such
        profiles."vodots" = {
          isDefault = true;
          search = {
            default = "ddg";
            privateDefault = "ddg";
          };

          # Use Betterfox
          preConfig = "${builtins.readFile ./user.js}";

          # Just some settings
          settings = {
            # Don't hide the tab bar when fullscreen
            "browser.fullscreen.autohide" = false;

            # Stop the alt key from toggling some menu
            "ui.key.menuAccessKeyFocuses" = false;
          };

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
