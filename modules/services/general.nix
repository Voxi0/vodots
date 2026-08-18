{self, ...}: {
  # NixOS specific services
  flake.modules.nixos = {
    # Firmware update manager
    fwupd = {services.fwupd.enable = true;};

    # Xorg/X11 windowing system
    xserver = {
      services.xserver = {
        enable = true;
        xkb.layout = self.kbLayout;
      };
    };

    # Audio server
    pipewire = {
      # Optional but recommended since it allows Pipewire to use the realtime scheduler for increased performance
      security.rtkit.enable = true;

      # Audio server
      services.pipewire = {
        enable = true;
        audio.enable = true;
      };
    };

    # Networking utilities
    ssh = {
      services.openssh = {
        enable = true;
        openFirewall = false;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = true;
          LogLevel = "INFO";
        };
      };
    };

    # A DBus daemon that allows one to change the system behaviour based on user-selected power profiles
    power-profiles-daemon = {
      services.power-profiles-daemon.enable = true;
    };

    # AppArmor - Linux kernel security module - Application security system
    apparmor = {
      security.apparmor.enable = true;
    };

    # Support for the Yubikey hardware security key
    yubikey = {
      services = {
        pcscd.enable = true;
        yubikey-agent.enable = true;
      };
      programs = {
        yubikey-manager.enable = true;
        yubikey-touch-detector.enable = true;
      };
    };
  };

  # Home Manager specific services - Also available as NixOS services but we use Home Manager when we can
  flake.modules.homeManager = {
    # Audio processing tool to apply real-time effects like equalizers and stuff to audio input/output
    easyeffects = {
      services.easyeffects.enable = true;
    };
  };
}
