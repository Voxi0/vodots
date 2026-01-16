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
  ];
  hmModules = with self.modules.homeManager;
    [general roblox]
    ++ (with self.inputs; [nix-flatpak.homeManagerModules.nix-flatpak]);
in {
  flake = {
    nixosConfigurations.${hostname} = self.lib.mkNixosHost {inherit hostname modules hmModules;};
    modules = {
      nixos.${hostname} = {};
      homeManager.${hostname} = {pkgs, ...}: {
        home.packages = with pkgs; [
          kitty
          halloy
          (pkgs.prismlauncher.override {
            jdks = [pkgs.graalvmPackages.graalvm-ce];
          })
        ];
      };
    };
  };
}
