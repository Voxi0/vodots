{
  flake.modules.homeManager.yazi = {
    home.shellAliases.yy = "yazi";
    programs.yazi = {
      enable = true;
    };
  };
}
