{
  flake.modules.nixos = {
    # Pipewire audio server
    pipewire = {
      security.rtkit.enable = true; # Real-time CPU scheduler for increased performance
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };

    # Bluetooth
    bluetooth = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
        settings = {
          General = {
            # Enable A2DP sink since modern headsets generally try to connect using that profile
            Enable = "Source,Sink,Media,Socket";

            # Show battery charge of bluetooth devices
            Experimental = true;
          };
        };
      };
    };

    # Yubikey - Security key
    yubikey = {
      services.yubikey-agent.enable = true;
      programs = {
        yubikey-manager.enable = true;
        yubikey-touch-detector.enable = true;
      };
    };
  };
}
