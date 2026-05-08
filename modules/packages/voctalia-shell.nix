{inputs, ...}: {
  # Noctalia shell
  flake.wrappers.voctalia-shell = {
    wlib,
    lib,
    config,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.noctalia-shell];
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    outOfStoreConfig = "$HOME/.config/noctalia";
    constructFiles.config = {
      content = builtins.readFile ../../config/noctalia.toml;
      relPath = "${config.generatedConfigDirname}/config.toml";
    };
  };
}
