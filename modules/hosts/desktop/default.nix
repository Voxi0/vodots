{self, ...}: let
  hostname = "desktop";
  modules = with self.modules.nixos; [
    general
    audio
    tailscale
    ssh
    yubikey
  ];
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname modules;};
    modules = {
      nixos.${hostname} = {};
      homeManager.${hostname} = {};
    };
  };
}
