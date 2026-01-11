{
  self,
  withSystem,
  ...
}: {
  flake.lib = {
    # Get all Home Manager modules
    hmModules = hostname: let
      hm = self.modules.homeManager;
    in
      with self.inputs;
        []
        ++ [hm.${hostname}]
        ++ (with hm; [general]);

    # Create a new NixOS configuration/host
    mkNixosHost = hostname:
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
                users.${self.username}.imports = self.lib.hmModules hostname;
              };
            }
          ]
          ++ (with self.inputs; [
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
          ])
          ++ (with self.modules.nixos; [
            general
          ]);
      };

    # Create a new Home Manager config
    mkHmConfig = hostname:
      self.inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = withSystem "x86_64-linux" ({pkgs, ...}: pkgs);
        modules = self.lib.hmModules hostname;
      };
  };
}
