{
  self,
  inputs,
  ...
}: {
  # Discord (Vencord) configured declaratively using Nix
  flake.modules.homeManager.discord = {
    imports = [inputs.nixcord.homeModules.nixcord];
    programs.nixcord = {
      enable = true;
      equibop.enable = true;
      discord = {
        enable = false;
        vencord.enable = false;
        equicord.enable = true;
        openASAR.enable = false;
      };

      # Styling and plugins
      config = {
        # Styles/Themes
        frameless = false;
        useQuickCss = false;

        # Plugins
        plugins = {
          # Fakin' Nitro
          fakeNitro.enable = true;
          USRBG.enable = true;
          UserPFP.enable = true;

          # Fun
          fontLoader.enable = true;
          gitHubRepos.enable = true;

          # Useful
          readAllNotificationsButton.enable = true;
          messageLogger.enable = true;
          timezones.enable = true;
          relationshipNotifier.enable = true;
          alwaysTrust.enable = true;
          PinDMs.enable = true;
          CustomRPC.enable = true;
          BlurNSFW.enable = true;
          spotifyCrack.enable = true;
          youtubeAdblock.enable = true;
          ClearURLs.enable = true;
          customIdle = {
            enable = true;
            idleTimeout = 0.0;
          };

          # LastFM - Music scrobbler
          LastFMRichPresence = {
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
