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
    hostname = "desktop";
    username = "voxi0";
    locale = "en_GB.UTF-8";
    kbLayout = "gb";

    # NixOS and Home Manager
    nixosConfigurations = lib.genAttrs hostnames self.lib.mkNixosHost;
    homeConfigurations = lib.genAttrs hostnames self.lib.mkHmConfig;
    # homeModules = lib.genAttrs hostnames hmModules;
  };
}
