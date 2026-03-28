{self, ...}: let
  hostname = "server";
  modules = with self.modules.nixos; [
    # Base
    general

    # Services
    fwupd
    tailscale
    cloudflared
    immich
    navidrome
    minecraft-server
    ssh
  ];
in {
  flake = {
    username = "server";
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname modules;};
    modules.nixos.${hostname} = {pkgs, ...}: {
      # Boot
      console = {
        earlySetup = true;
        useXkbConfig = true;
        font = "Lat2-Terminus16";
      };

      # Stop laptops from suspending when lid is closed
      boot.kernelParams = ["video=LVDS-1:d"];
      systemd.sleep.settings.Sleep = {
        AllowSuspend = false;
        AllowHibernation = false;
        AllowHybridSleep = false;
        AllowSuspendThenHibernate = false;
      };
    };
  };
}
