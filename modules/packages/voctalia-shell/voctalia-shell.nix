{
  # Noctalia shell
  flake.wrappers.voctalia-shell = {wlib, ...}: {
    imports = [wlib.wrapperModules.noctalia-shell];
    inherit (builtins.fromJSON (builtins.readFile ./noctalia.json)) settings;
  };
}