{
  self,
  inputs,
  ...
}: {
  flake.modules.nixos = let
    navidromeMusicFolder = "/music";
    postgresqlDataDir = "/var/lib/postgresql";
    immichDataDir = "/var/lib/immich";
    minecraftServersDataDir = "/var/lib/minecraft-servers";
  in {
    tailscale = {config, ...}: {
      services.tailscale = {
        enable = true;
      };

      networking.firewall = {
        # Always allow traffic from your Tailscale network
        trustedInterfaces = [config.services.tailscale.interfaceName];

        # Allow the Tailscale UDP port through the firewall
        allowedUDPPorts = [config.services.tailscale.port];
      };

      # Force `tailscaled` to use `nftables` which is critical for clean nftables-only systems
      # This avoids the `iptables-compat` translation layer issues
      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      # Prevent `systemd` from waiting for network online
      # Optional but recommended for faster boot with VPNs
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;
    };

    # Intrusion prevention software to protect servers from brute-force attacks by monitoring log files for malicious patterns
    # For example, multiple failed login attempts
    # It works by updating firewall rules to temporarily or permanently ban suspicious IP addresses
    fail2ban = {
      services.fail2ban = {
        enable = true;
        maxretry = 3;
        ignoreIP = [
          # All personal devices in the tailnet (Tailscale network)
          "100.64.0.0/10"
        ];
      };
    };

    # Self-hosted alternative to Google Photos for photo and video management
    immich = {
      config,
      pkgs,
      ...
    }: {
      # Required for Immich to be able to display videos and such
      users.users.immich.extraGroups = ["video" "render"];

      services = {
        # Database - Stores user data, album data, etc.
        postgresql = {
          package = pkgs.postgresql_18;
          extensions = ps: with ps; [vectorchord pgvector];
          dataDir = "${postgresqlDataDir}/${config.services.postgresql.package.psqlSchema}";
        };
        immich = {
          enable = true;
          openFirewall = false;
          host = "0.0.0.0";
          port = 2283;
          accelerationDevices = null;
          mediaLocation = immichDataDir;
        };
      };
    };

    # Music streaming service
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

    # Fabric Minecraft server
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
      imports = [inputs.nix-minecraft.nixosModule.minecraft-servers];
      services.minecraft-servers = {
        enable = true;
        eula = true;
        dataDir = minecraftServersDataDir;
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
            motd = "${self.username}'s Minecraft servoooor";

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

          # Operators
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
