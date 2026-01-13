{
  self,
  inputs,
  ...
}: let
  hostnames = inputs.nixpkgs.lib.attrNames (builtins.readDir ../hosts);
in {
  # Import flake-parts stuff
  imports = with inputs; [
    flake-parts.flakeModules.modules
    home-manager.flakeModules.home-manager
  ];

  # Flake
  flake = {
    # Globals
    username = "voxi0";
    locale = "en_GB.UTF-8";
    kbLayout = "gb";

    # Export all our custom Home Manager modules
    homeModules = builtins.removeAttrs self.modules.homeManager hostnames;
  };
}
