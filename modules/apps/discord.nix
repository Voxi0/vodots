{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.discord = {
    imports = [inputs.nixcord.homeModules.nixcord];
    programs.nixcord = {
      enable = true;

      # Client
      discord.enable = false;
      goofcord = {
        enable = true;
        clientMod = "equicord";
      };

      # Settings and plugins
      config = {
        useQuickCss = true;
        themeLinks = ["https://refact0r.github.io/system24/build/system24.css"];

        # Plugins
        plugins = {
          ##########
          ### UI ###
          ##########
          declutter.enable = true; # Removes non-essential UI elements e.g. the shop tabs and profile effects
          noTypingAnimation.enable = true;
          alwaysExpandProfiles.enable = true; # Expand profile popouts fully
          betterAudioPlayer.enable = true; # Spectograph and oscilloscope visualizer to audio attachment players
          fontLoader.enable = true; # Load whatever font from Google fonts
          typingTweaks.enable = true; # Shows avatars and role colors in the typing indicator
          wigglyText.enable = true; # New Markdown formatting to make wiggly text

          ##############
          ### Useful ###
          ##############
          invisibleChat.enable = true; # Encrypt your messages
          iRememberYou.enable = true; # Locally save everyone you've been communicating with in case of loss
          readAllNotificationsButton.enable = true; # Mark all messages as seen/read
          downloadAllAttachments.enable = true; # Popover button to download all attachments at once
          fakeNitro.enable = true; # Use nitro themes, fake emojis/stickers and stream in Nitro quality
          messageLoggerEnhanced.enable = true;
          pinDms.enable = true; # Pin private channels to the top of your DMs list
          fileUpload.enable = true; # Upload files to hosting services e.g. Zipline, Nest, S3 and WebDAV
          gifMaker.enable = true; # Enable create and caption GIFs from any media in chat or the GIF picker
          betterGifPicker.enable = true; # Open the favourite category by default in the GIF picker
          clearUrls.enable = true; # Clear tracking elements and such from URLs
          experiments.enable = true; # Access to experiments and other dev-only-features
          alwaysTrust.enable = true; # Removes annoying untrusted domain and suspicious file popups
          relationshipNotifier.enable = true; # Notifications when a friend, group chat or server removes you
          spotifyCrack.enable = true; # Listen along on Spotify among other things without Spotify premium

          #####################
          ### Miscellaneous ###
          #####################
          petpet.enable = true; # Adds a "/petpet" command to create headpat gifs from any image
          # Add badges showcasing how long you've been friends with a user for
          friendshipRanks = {
            enable = true;
            showFriendsInChat = true;
          };

          # Share LastFM/Listenbrainz status
          musicRichPresence = {
            enable =
              if self.lastFmUsername != ""
              then true
              else false;
            scrobblerBackend = "lastfm";
            username = self.lastFmUsername;
            shareUsername = true;
            useListeningStatus = true;
          };
        };
      };
    };
  };
}
