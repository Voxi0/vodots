{self, ...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home = {
      # I prefer Neovim over Vi and Vim
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };

      # Install my personal Neovim configuration with some customizations or whatever
      packages = [
        (self.packages.${pkgs.stdenv.hostPlatform.system}.vonvim.wrap ({pkgs, ...}: {
          extraPackages = with pkgs; [
            # Language server + Formatter
            clang-tools # C/C++

            # Language servers
            lua-language-server # Lua
            nil # Nix
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
              conform-nvim
              vim-wakatime
            ];

            # Extra Lua configuration
            config = ''
              -- Enable whatever LSPs I want
              vim.lsp.enable({ "lua_ls", "nil_ls", "clangd", "zls", "astro" })

              -- Load/Configure plugins
              require("lze").load({
                -- Set up formatters for various filetypes
                {
                  "conform.nvim",
                  keys = {
                    {
                      "<leader>mp",
                      mode = "n",
                      desc = "Format current buffer",
                      function()
                        require("conform").format({
                          lsp_fallback = false,
                          async = true,
                          timeout_ms = 500,
                        })
                      end,
                    },
                  },
                  after = function()
                    require("conform").setup({
                      default_format_opts = {
                        lsp_format = "fallback",
                      },
                      formatters_by_ft = {
                        lua = { "stylua" },
                        nix = { "alejandra" },
                        c = { "clang-format" },
                        cpp = { "clang-format" },
                        zig = { "zigfmt" },
                      },
                    })
                  end,
                },

                -- Wakatime
                { "vim-wakatime", lazy = false },
              })
            '';
          };
        }))
      ];
    };
  };
}