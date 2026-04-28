{inputs, ...}: {
  flake.modules.homeManager = {
    helium-browser = {pkgs, ...}: {
      home.packages = [inputs.helium.packages.${pkgs.system}.default];
    };
  };
}
