{
  flake.modules.homeManager.vscode = {pkgs, ...}: {
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium-fhs;
    };
  };
}