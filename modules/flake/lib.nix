{
  self,
  withSystem,
  ...
}: {
  flake.lib = {
    # Create a new NixOS configuration/host
    mkNixosHost = {
      hostname,
      modules ? [],
      hmModules ? [],
    }:
      self.inputs.nixpkgs.lib.nixosSystem {
        modules =
          [
            ../hosts/${hostname}/_disko.nix
            self.modules.nixos.${hostname}
            {
              # Hardware configuration
              hardware.facter.reportPath = ../hosts/${hostname}/facter.json;

              # Set system hostname
              networking.hostName = hostname;

              # Home Manager
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = false;
                backupFileExtension = "bak";
                users.${self.username}.imports = [self.modules.homeManager.${hostname}] ++ hmModules;
              };
            }
          ]
          ++ (with self.inputs; [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
          ])
          ++ modules;
      };

    # Create a new Home Manager config
    mkHmConfig = {
      hostname,
      modules ? [],
    }:
      self.inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
        modules = [self.modules.homeManager.${hostname}] ++ modules;
        backupFileExtension = "bak";
      };
  };
}
