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
        (extension "darkreader" "addon@darkreader.org")
        (extension "disconnect" "2.0@disconnect.me")
        (extension "sink-it-for-reddit" "{09acf9ff-55d4-4366-a1a9-c9b3c8877c09}")
      ];
    in {
      home.packages = [
        (pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped {
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
