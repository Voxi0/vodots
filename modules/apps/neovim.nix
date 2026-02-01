{inputs, ...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home = {
      # I prefer Neovim over Vi and Vim
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };

      # Install my personal Neovim configuration with some customizations or whatever
      packages = [
        (inputs.nvdots.packages.${pkgs.stdenv.hostPlatform.system}.neovim.wrap ({pkgs, ...}: {
          extraPackages = with pkgs; [
            # Language servers
            clang-tools # C/C++
            nil # Nix
            lua-language-server # Lua
            astro-language-server # AstroJS - Webdev framework

            # For the Wakatime plugin
            wakatime-cli
          ];
          specs.general = {
            data = [pkgs.vimPlugins.vim-wakatime];
            config = ''
              -- Load Wakatime plugin
              vim.cmd.packadd("vim-wakatime")

              -- Enable LSP configurations for whatever languages I want
              vim.lsp.enable({ "lua_ls", "nil_ls", "clangd", "zls", "astro" })
            '';
          };
        }))
      ];
    };
  };
}
