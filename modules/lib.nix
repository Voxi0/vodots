{
  self,
  inputs,
  ...
}: {
  flake.lib = {
    # Create NixOS configuration host
    mkNixosHost = {
      hostname,
      nixosModules ? [],
      hmModules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        modules =
          [
            inputs.disko.nixosModules.disko

            self.modules.nixos.${hostname}
            self.modules.nixos.general
            ./hosts/${hostname}/_disko.nix
            ./hosts/${hostname}/_hardware-configuration.nix
            {
              # System hostname
              networking.hostName = hostname;
            }
          ]
          ++ nixosModules
          ++ (
            if hmModules != []
            then [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${self.username}.imports =
                    [
                      self.modules.homeManager.${hostname}
                      self.modules.homeManager.general
                    ]
                    ++ hmModules;
                };
              }
            ]
            else []
          );
      };

    # Create Home Manager host
    mkHmHost = {
      pkgs,
      hmModules ? [],
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [self.modules.homeManager.general] ++ hmModules;
      };
  };
}
