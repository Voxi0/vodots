{inputs, ...}: {
  flake.modules.homeManager = {
    zen-browser = {pkgs, ...}: let
      extension = shortId: guid: {
        name = guid;
        value = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
      extensions = [
        (extension "ublock-origin" "uBlock0@raymondhill.net")
      ];
    in {
      home.packages = [
        (pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped {
          extraPolicies = {
            DisableTelemetry = true;
            ExtensionSettings = builtins.listToAttrs extensions;
            SearchEngines.Default = "ddg";
          };
        })
      ];
    };
  };
}
