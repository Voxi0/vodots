{self, ...}: let
  hostname = "server";
  modules = with self.modules.nixos; [
    # Base
    general

    # Services
    fwupd
    ssh
    tailscale
    immich
    navidrome
    minecraft-server
  ];
in {
  flake = {
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

      # Some extra packages just for this host
      environment.systemPackages = with pkgs; [
        # Cloudflare daemon - I use tunnels to easily and securely expose server services e.g. Immich to the wider internet without port forwarding
        cloudflared
      ];
    };
  };
}
