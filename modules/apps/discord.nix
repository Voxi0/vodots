{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.discord = {
    imports = [inputs.nixcord.homeModules.nixcord];
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      goofcord = {
        enable = true;
        clientMod = "equicord";
        settings = {
          minimizeToTray = true;
          hardwareAcceleration = true;
        };
      };

      config = {
        # Plugins
        plugins = {
          # Handy
          readAllNotificationsButton.enable = true;
          messageLoggerEnhanced.enable = true;
          pinDms.enable = true;
          relationshipNotifier.enable = true; # Notifications for when a friend, group chat, or server removes you
          reverseImageSearch.enable = true;
          spotifyCrack.enable = true; # Spotify listen along etc etc
          autoZipper.enable = true; # Automatically zip specified file types and folders before uploading to Discord
          youtubeAdblock.enable = true; # Get rid of YouTube ads in Discord
          alwaysTrust.enable = true; # Remove untrusted domain and suspicious file popup

          # UI stuff
          declutter.enable = true; # Remove non-essential UI elements
          noTypingAnimation.enable = true;
          fontLoader.enable = true; # Load any font from Google Fonts
          petpet.enable = true;

          # Nitro features
          fakeNitro.enable = true; # Use whatever emoji + stickers without Nitro and screenshare in Nitro quality
          userPfp.enable = true; # Use animated profile pictures

          # LastFM rich presence
          musicRichPresence = {
            enable = true;
            shareUsername = true;
            statusName = "moozic";
            useListeningStatus = true;
            username = self.lastFmUsername;
          };
        };
      };
    };
  };
}
