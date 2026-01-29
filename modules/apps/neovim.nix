{
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    # I prefer Neovim over Vi and Vim
    home.shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    # My personal Neovim configuration using nixCats
    nvdots = {
      enable = true;
      packageNames = ["nvdots"];

      # Add extra plugins on top
      categoryDefinitions.merge = {...}: {
        # Add Wakatime plugin
        lspsAndRuntimeDeps.general.deps = [pkgs.wakatime-cli];
        optionalPlugins.general.misc = [pkgs.vimPlugins.vim-wakatime];
        optionalLuaAdditions.general = [
          "vim.cmd.packadd('vim-wakatime')"
        ];
      };
    };
  };
}
