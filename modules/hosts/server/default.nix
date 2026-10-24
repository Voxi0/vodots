{self, ...}: let
  hostname = "server";
  nixosModules = with self.modules.nixos; [
    tailscale
    glance
    immich
    navidrome
    couchDb
    fail2ban
  ];
in {
  flake = {
    # Create a NixOS configuration/host
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname nixosModules;};

    # Extra host specific configuration
    modules.nixos.${hostname} = {
      # Swap
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      # Firmware Update Manager
      services.openssh.enable = true;
    };
  };
}
