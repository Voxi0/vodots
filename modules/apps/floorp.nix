{
  flake.modules.homeManager.floorp = {
    lib,
    pkgs,
    ...
  }: let
    defaultProfileName = "vodots";
  in {
    home.file.".floorp/${defaultProfileName}/search.json.mozlz4".force = lib.mkForce true;
    programs.floorp = {
      enable = true;

      # Policies
      policies = {
        HardwareAcceleration = true;

        # Telemetry and features
        DisableTelemetry = true;
        DisablePocket = true;
        DisableFirefoxScreenshots = true;
        DisableFirefoxStudies = true;

        # UI
        DisplayMenuBar = "never";
      };

      # Default profile - Config, extensions and all
      profiles."${defaultProfileName}" = {
        # Use Betterfox
        extraConfig = let
          userJs = pkgs.fetchFromGitHub {
            owner = "yokoffing";
            repo = "Betterfox";
            rev = "067172a4b0dc90e78e5b8b94d9abfe6430c6a7be";
            hash = "sha256-mIP/WcXUcGrJsWCJzR4zqPOmt0BbbpTZVaN/MbIwBbw=";
          };
        in "${userJs}/Fastfox.js}";

        # Extra settings
        settings = {
          "browser.fullscreen.autohide" = false;
        };

        # Search engines
        search = {
          default = "ddg";
          privateDefault = "ddg";
        };

        # Extensions
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin # Efficient Ad-Blocker
          disconnect # Block thousands or so of hidden trackers making pages load upto 44% faster
          youtube-nonstop # Disable the "Video paused. Continue watching?" confirmation dialogue on YouTube
          stylus # User-style manager to easily redesign websites
          darkreader # Dark mode for websites
        ];
      };
    };
  };
}
