{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos.minecraft-server = {
    lib,
    pkgs,
    ...
  }: let
    modpack = pkgs.fetchPackwizModpack {
      url = "https://tangled.org/voxi0.tngl.sh/meinpack/raw/main/pack.toml";
      packHash = "sha256-47DqKXiRv1Pn1ugdDgwe/znhORyOdr+Pb7aeyCDRGj8=";
    };

    # Figure out the Minecraft, Fabric and server version
    mcVersion = modpack.manifest.versions.minecraft;
    fabricVersion = modpack.manifest.versions.fabric;
    serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
  in {
    imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

    # Minecraft servers
    services.minecraft-servers = {
      enable = true;
      eula = true;
      dataDir = "/var/lib/minecraft-servers";
      servers.default = {
        enable = true;
        autoStart = false;
        package = pkgs.fabricServers.${serverVersion}.override {
          jre_headless = pkgs.graalvmPackages.graalvm-ce;
          loaderVersion = fabricVersion;
        };
        jvmOpts = ''
          -Xms2G -Xmx16G \
          -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+UseStringDeduplication \
          -Djava.net.preferIPv4Stack=true
        '';
        serverProperties = {
          motd = "${self.username}'s Minecraft server";

          # Gameplay
          gamemode = "survival";
          difficulty = "normal";
          max-players = 10;
          allow-cheats = false;
          pvp = true;
          generate-structures = true;

          # Performance
          max-threads = 2;
          view-distance = 8;
          simulation-distance = 6;
          use-native-transport = true;
          sync-chunk-writes = false; # Allows the server to save chunks off the main thread, lessening the load on the main tick loop
          spawn-protection = 0; # Any player can place blocks and stuff around worldspawn
          max-tick-time = 60000; # Give server 60s per tick before watchdog kicks in

          # Logging / Status
          broadcast-console-to-ops = true;
          broadcast-rcon-to-ops = true;
          enable-status = true;
          snooper-enabled = false;
        };

        # Use the mods and their config files from the modpack
        symlinks = inputs.nix-minecraft.lib.collectFilesAt modpack "mods" // {};
        files =
          lib.optionalAttrs (builtins.pathExists "${modpack}/config")
          (inputs.nix-minecraft.lib.collectFilesAt modpack "config")
          // {};

        # Players configuration
        operators.MiniVoxi = {
          uuid = "9c49e463-ae94-49c4-a311-9553cb5ed29c";
          level = 4;
          bypassesPlayerLimit = true;
        };
      };
    };
  };
}
