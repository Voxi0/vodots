{self, ...}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home = {
      shellAliases."nv" = "nvim";
      packages = [
        (self.packages.${pkgs.stdenv.hostPlatform.system}.vonvim.wrap ({pkgs, ...}: {
          runtimePkgs = with pkgs; [
            # Language servers
            nil # Nix
            lua-language-server # Lua

            # Required for the Wakatime plugin
            wakatime-cli
          ];
          specs.general = {
            data = [pkgs.vimPlugins.vim-wakatime];
            config = ''
              -- Enable whatever LSPs I want
              vim.lsp.enable({ "lua_ls", "nil_ls", "clangd", "rust_analyzer", "astro" })

              -- Load and configure plugins
              require("lze").load({
                {"vim-wakatime", lazy = false},
              })
            '';
          };
        }))
      ];
    };
  };
}
