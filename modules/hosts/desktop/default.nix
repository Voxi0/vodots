{self, ...}: let
  hostname = "desktop";
  modules = with self.modules.nixos; [
    general
    audio
    tailscale
    ssh
    yubikey
  ];
  hmModules = with self.modules.homeManager; [general];
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname modules hmModules;};
    modules = {
      nixos.${hostname} = {};
      homeManager.${hostname} = {};
    };
  };
}
