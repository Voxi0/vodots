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
        (pkgs.neovim.wrap ({pkgs, ...}: {
          extraPackages = with pkgs; [
            # Language servers
            lua-language-server # Lua
            nil # Nix
            clang-tools # C/C++
            astro-language-server # AstroJS - Webdev framework

            # Formatters
            stylua # Lua
            alejandra # Nix

            # For the Wakatime plugin
            wakatime-cli
          ];
          specs.general = {
            # Extra plugins
            data = with pkgs.vimPlugins; [
              vim-wakatime
              hardtime-nvim
            ];

            # Extra Lua configuration
            config = ''
              -- Load plugins
              vim.cmd.packadd("vim-wakatime")

              -- Enable LSP configurations for whatever languages I want
              vim.lsp.enable({ "lua_ls", "nil_ls", "clangd", "zls", "astro" })

              -- Set up formatters for various filetypes
              vim.cmd.packadd("conform.nvim")
              require("conform").setup({
                formatters_by_ft = {
                  lua = { "stylua" },
                  nix = { "alejandra" },
                  c = { "clang-format" },
                  cpp = { "clang-format" },
                  zig = { "zigfmt" },
                },
              })

              -- Force you to get better at Vim/Neovim motions
              vim.cmd.packadd("hardtime.nvim")
              require("hardtime").setup()
            '';
          };
        }))
      ];
    };
  };
}
