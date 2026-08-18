{
  self,
  inputs,
  ...
}: {
  # Common functions
  flake.lib = {
    # Create a new NixOS configuration/host
    mkNixosHost = {
      hostname,
      nixosModules ? [],
      hmModules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        modules =
          [
            # Disko
            inputs.disko.nixosModules.disko
            ./hosts/${hostname}/_disko.nix

            # Host specific configuration
            self.modules.nixos.${hostname}
            {
              # Hardware report and system hostname
              hardware.facter.reportPath = ./hosts/${hostname}/facter.json;
              networking.hostName = hostname;
            }
          ]
          ++
          # Extra NixOS modules the host wanted to use
          nixosModules
          ++ (
            # Import Home Manager and the specified modules if any Home Manager modules are provided
            if hmModules != []
            then [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = false;
                  backupFileExtension = "bak";
                  overwriteBackup = true;

                  # Host specific Home Manager configuration and any specified modules
                  users.${self.username}.imports = [self.modules.homeManager.${hostname}] ++ hmModules;
                };
              }
            ]
            else []
          );
      };
  };
}
