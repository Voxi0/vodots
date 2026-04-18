{self, ...}: {
  flake.modules.nixos = let
    navidromeMusicFolder = "/music";
  in {
    # Firmware update manager
    fwupd = {
      services.fwupd.enable = true;
    };

    # Xorg/X11
    xserver = {
      services.xserver = {
        enable = true;
        xkb.layout = self.kbLayout;
      };
    };

    # Pipewire for audio
    audio = {
      services.pipewire = {
        enable = true;
        audio.enable = true;
      };
    };

    # Secure Shell utilities (SSH)
    ssh = {
      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = true;
          LogLevel = "VERBOSE";
        };
      };
    };

    # Tailscale - Private mesh VPN that makes it easy to connect your devices together
    tailscale = {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = ["tailscale0"];
    };

    # Server dashboard
    glance = {
      services.glance = {
        enable = true;
        settings.server.host = "0.0.0.0";
      };
    };

    # Intrusion prevention software framework that protects Linux servers from brute-force attacks by monitoring log files for malicious patterns
    # For example, multiple failed login attempts
    # It works by updating firewall rules (using iptables or firewalld) to temporarily or permanently ban suspicious IP addresses
    fail2ban = {
      services.fail2ban = {
        enable = true;
        maxretry = 3;
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
          extraPlugins = ps: with ps; [vectorchord pgvector];
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

    # Printing support
    printing = {
      services.printing.enable = true;
    };

    # Support for the Yubikey hardware security key
    yubikey = {
      services.pcscd.enable = true;
      services.yubikey-agent.enable = true;
      programs = {
        yubikey-manager.enable = true;
        yubikey-touch-detector.enable = true;
      };
    };
  };
}
