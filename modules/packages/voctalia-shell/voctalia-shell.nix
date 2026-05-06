{inputs, ...}: {
  # Noctalia shell
  flake.wrappers.voctalia-shell = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.noctalia-shell];
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    inherit (builtins.fromJSON (builtins.readFile ./noctalia.json)) settings;
  };
}
