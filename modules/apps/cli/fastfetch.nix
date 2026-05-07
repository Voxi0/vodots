{self, ...}: {
  # Just a sysfetch to show off
  flake.modules.homeManager.fastfetch = {pkgs, ...}: {
    home = {
      shellAliases.ff = "fastfetch";
      packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.vofetch];
    };
  };
}