{
  # NixOS specific
  flake.modules.nixos = {
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
  };
}
