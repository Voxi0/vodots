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
        };
      };
    };

    # Tailscale - Private mesh VPN that makes it easy to connect your devices together
    tailscale = {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = ["tailscale0"];
    };

    # Cloudflare tunnels for easily securely exposing server services e.g. Immich to the wider internet without port forwarding
    cloudflared = {
      services.cloudflared.enable = true;
    };

    # Self-hosted photo and video management solution - Best self-hosted alternative to something like Google Photos
    immich = {
      # Required for Immich to be able to display videos and stuff
      users.users.immich.extraGroups = ["video" "render"];

      services.immich = {
        enable = true;
        openFirewall = true;
        host = "0.0.0.0";
        port = 2283;
        accelerationDevices = null;
      };
    };

    # Music streaming service - Selfhosting music is cool no?
    navidrome = {
      services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          Port = 4533;
          MusicFolder = navidromeMusicFolder;
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
