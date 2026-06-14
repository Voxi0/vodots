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
      discord.enable = false;
      equibop.enable = true;

      # Styling and plugins
      config = {
        # Styles/Themes
        frameless = false;
        useQuickCss = false;

        # Plugins
        plugins = {
          # Fakin' Nitro
          fakeNitro.enable = true;

          # Useful
          readAllNotificationsButton.enable = true;
          messageLogger.enable = true;
          relationshipNotifier.enable = true;
          alwaysTrust.enable = true;
          customRpc.enable = true;
          blurNsfw.enable = true;
          spotifyCrack.enable = true;
          youtubeAdblock.enable = true;
          clearUrls.enable = true;
          customIdle = {
            enable = true;
            idleTimeout = 0.0;
          };

          # LastFM - Music scrobbler
          lastFmRichPresence = {
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