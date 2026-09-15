{
  # NixOS specific
  flake.modules.nixos = {
    # Intel support
    intel-graphics = {pkgs, ...}: {
      environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
      hardware = {
        intel-gpu-tools.enable = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
          ];
        };
      };
    };

    # Nvidia support
    nvidia-graphics = {
      # Saves and restores GPU memory during system suspend and hibernation
      boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

      # NVidia drivers
      services.xserver.videoDrivers = ["nvidia"];
      hardware = {
        graphics.enable = true;
        nvidia = {
          open = false; # Use proprietary drivers since they tend to offer better performance for now
          modesetting.enable = true; # Wayland requires Kernel Mode Setting (KMS) - Highly recommended
          nvidiaSettings = true; # Settings application

          # Required for a computer with Nvidia to go to sleep/suspend and wake up properly
          powerManagement = {
            enable = true;
            finegrained = false;
          };
        };
      };
    };

    # AMD support
    amd-graphics = {
      hardware.graphics = {
        enable = true;
      };

      # Allows you to overclock, undervolt, set fans curves of AMD GPUs
      services.lact.enable = true;
    };

    # Graphics/Drawing tablet support
    openTabletDriver = {
      boot.kernelModules = ["uinput"];
      hardware = {
        uinput.enable = true;
        opentabletdriver.enable = true;
      };
    };
  };
}
