{self, ...}: {
  flake.modules = {
    # NixOS specific
    nixos = {
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
        # Audio server
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
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            LogLevel = "VERBOSE";
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

    # Home Manager specific
    homeManager = {
      # Audio processing tool to apply real-time effects like equalizers and stuff to audio input/output
      easyeffects = {
        services.easyeffects.enable = true;
      };
    };
  };
}
