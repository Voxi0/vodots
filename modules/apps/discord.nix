{
  flake.modules.homeManager.discord = {
    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      discord.openASAR.enable = true;

      # Styling and plugins
      config = {
        # Styles/Themes
        frameless = false;
        useQuickCss = false;
        enabledThemes = [];
        themeLinks = [
          "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/flavors/midnight-catppuccin-mocha.theme.css"
        ];

        # Plugins
        plugins = {
          # Essentials
          fakeNitro.enable = true;
          PinDMs.enable = true;
          plainFolderIcon.enable = true;
          readAllNotificationsButton.enable = true;
          youtubeAdblock.enable = true;

          # Spotify
          spotifyCrack.enable = true;
          spotifyControls.enable = true;
          spotifyShareCommands.enable = true;

          # LastFM
          LastFMRichPresence = {
            enable = true;
            hideWithSpotify = false;
            username = "voxi0";
            shareUsername = true;
            useListeningStatus = true;
          };

          # Cool
          noTypingAnimation.enable = true;
          alwaysTrust.enable = true;
          OnePingPerDM.enable = true;
          messageLogger.enable = true;
          friendsSince.enable = true;
          relationshipNotifier.enable = true;
          customIdle = {
            enable = true;
            remainInIdle = true;
            idleTimeout = 0.0;
          };

          # More stuff
          petpet.enable = true;
          webKeybinds.enable = true;
          ClearURLs.enable = true;

          # Fixes
          fixSpotifyEmbeds.enable = true;
          fixImagesQuality.enable = true;
          webScreenShareFixes.enable = true;
        };
      };
    };
  };
}
