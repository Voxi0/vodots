{
  self,
  inputs,
  ...
}: let
  inherit (self.inputs.nixpkgs) lib;
  hostnames = lib.attrNames (builtins.readDir ../hosts);
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

    # Home Manager
    homeConfigurations = lib.genAttrs hostnames (hostname: self.lib.mkHmConfig hostname);
    homeModules = lib.genAttrs hostnames (hostname: self.lib.hmModules hostname);
  };
}
