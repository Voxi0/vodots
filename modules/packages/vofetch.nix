{
  flake.wrappers.vofetch = {wlib, ...}: {
    imports = [wlib.wrapperModules.fastfetch];
    settings = builtins.fromJSON (builtins.readFile ../../config/fastfetch.json);
  };
}