{
  flake.modules.nixos = {
    # An open source, cross-platform, low latency, user-mode tablet driver
    # Should work for most tablets
    openTabletDriver = {
      boot.kernelModules = ["uinput"];
      hardware = {
        opentabletdriver.enable = true;
        uinput.enable = true;
      };
    };
  };
}
