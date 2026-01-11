{self, ...}: {
  flake.modules = {
    nixos.desktop = {};
    homeManager.desktop = {};
  };
}
