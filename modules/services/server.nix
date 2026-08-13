{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos = let
    navidromeMusicFolder = "/music";
  in {
    # Tailscale - Private mesh VPN that makes it easy to connect your devices together
    tailscale = {
      networking.firewall.trustedInterfaces = ["tailscale0"];
      services.tailscale.enable = true;
    };

    # Server dashboard
    glance = {
      services.glance = {
        enable = true;
        settings.server.host = "0.0.0.0";
      };
    };

    # Intrusion prevention software framework that protects servers from brute-force attacks by monitoring log files for malicious patterns
    # For example, multiple failed login attempts
    # It works by updating firewall rules (using iptables or firewalld) to temporarily or permanently ban suspicious IP addresses
    fail2ban = {
      services.fail2ban = {
        enable = true;
        maxretry = 3;
        ignoreIP = [
          # All devices in your tailnet (Tailscale network)
          "100.64.0.0/10"
        ];
      };
    };

    # Self-hosted photo and video management solution - Best self-hosted alternative to something like Google Photos
    immich = {
      config,
      pkgs,
      ...
    }: {
      # Required for Immich to be able to display videos and stuff
      users.users.immich.extraGroups = ["video" "render"];

      services = {
        # Immich uses Postgresql for the database - Stores user data, album data, etc.
        postgresql = {
          package = pkgs.postgresql_18;
          extensions = ps: with ps; [vectorchord pgvector];
          dataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
        };

        immich = {
          enable = true;
          openFirewall = true;
          host = "0.0.0.0";
          port = 2283;
          accelerationDevices = null;
          mediaLocation = "/var/lib/immich";
        };
      };
    };

    # Music streaming service - Selfhosting music is cool no?
    navidrome = {
      services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          Port = 4533;
          Address = "0.0.0.0";
          MusicFolder = navidromeMusicFolder;
          EnableSharing = true;
        };
      };
    };

    # Minecraft server of course, uses a Packwiz modpack for well, mods duh
    # It's really convenient to use Packwiz so please look into that
    minecraft-server = {
      lib,
      pkgs,
      ...
    }: let
      modpack = pkgs.fetchPackwizModpack {
        url = "https://tangled.org/voxi0.tngl.sh/meinpack/raw/main/pack.toml";
        packHash = "sha256-kAB6TptpKEkDG/aObXDT/hVI6NvC2fy/cDXTv8wkK3Q=";
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
  };
}