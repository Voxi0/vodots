{self}: {
  flake.modules.nixos = {
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

    # Tailscale - Private mesh VPN that makes it easy to connect your devices together
    tailscale = {
      services.tailscale.enable = true;
    };

    # Secure Shell (SSH)
    ssh = {
      services.openssh.enable = true;
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
