{self, ...}: let
  hostname = "desktop";
  modules = with self.modules.nixos; [
    general

    # Services
    audio
    tailscale
    ssh
    yubikey

    # Gaming
    gaming
    steam
    roblox
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
