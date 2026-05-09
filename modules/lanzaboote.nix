{inputs, ...}: {
  flake.modules.nixos = {
    lanzaboote = {
      lib,
      pkgs,
      ...
    }: {
      imports = [inputs.lanzaboote.nixosModules.lanzaboote];

      # Secure boot key manager
      environment.systemPackages = [pkgs.sbctl];

      boot = {
        # Lanzaboote currently replaces the systemd-boot module so we need to disable systemd-boot
        loader.systemd-boot.enable = lib.mkForce false;
        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
        };
      };
    };
  };
}
