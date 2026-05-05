{
  flake.wrappers.vokitty = {wlib, ...}: {
    imports = [wlib.wrapperModules.kitty];
    themeFile = "Carbonfox";
    extraConfig = builtins.readFile ../../config/kitty/kitty.conf;
  };
}