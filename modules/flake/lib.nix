{
  self,
  inputs,
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
      inputs.nixpkgs.lib.nixosSystem {
        modules =
          # NixOS modules
          [
            # Disko for managing disk layouts and stuff
            inputs.disko.nixosModules.disko
            ../hosts/${hostname}/_disko.nix

            # Host configuration
            self.modules.nixos.${hostname}
            {
              # Hardware configuration
              hardware.facter.reportPath = ../hosts/${hostname}/facter.json;

              # Set system hostname
              networking.hostName = hostname;
            }
          ]
          ++ modules
          # Import/Include/Use Home Manager only if atleast one Home Manager module is being used
          ++ (
            if hmModules != []
            then [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  backupFileExtension = "bak";
                  overwriteBackup = true;
                  users.${self.username}.imports = [self.modules.homeManager.${hostname}] ++ hmModules;
                };
              }
            ]
            else []
          );
      };

    # Create a new Home Manager config
    mkHmConfig = {
      hostname,
      modules ? [],
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
        modules = [self.modules.homeManager.${hostname}] ++ modules;
        backupFileExtension = "bak";
      };
  };
}