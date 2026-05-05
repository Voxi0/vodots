{
  flake.wrappers.vonvim = {
    wlib,
    lib,
    config,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.neovim];
    # Module options
    options.settings = {
      # Tell Lua which top-level specs are enabled
      cats = lib.mkOption {
        readOnly = true;
        type = lib.types.attrsOf lib.types.bool;
        default = builtins.mapAttrs (_: v: v.enable) config.specs;
      };
    };

    # Configuration
    config = {
      # package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
      package = pkgs.neovim-unwrapped;
      settings = {
        # Lua config directory
        # Can be an impure path so it won't be managed by Nix allowing normal reload for quick edits
        config_directory = ./.;

        # Uncomment this to allow installing multiple Neovim derivations without path collisions
        # dont_link = true;

        # Also ensure these don't share values
        # binName = "nvim";
        # settings.aliases = [ ];
      };

      # Plugins
      specs = {
        # Automatically loaded on startup by Neovim (No lazy-loading)
        # Don't mess with this. There's literally no reason to.
        plugin-manager.data = pkgs.vimPlugins.lze;

        # Lazy-loaded plugins
        ui = {
          lazy = true;
          after = ["startup"];
          data = with pkgs.vimPlugins; [
            # Colorscheme/Theme
            catppuccin-nvim

            # Icon pack
            mini-icons

            # Statusline
            lualine-nvim

            # Completely replaces the UI for messages, cmdline and the popupmenu
            noice-nvim

            # Dashboard, file picker, indent guides, LazyGit, better statuscolumn, smooth-scrolling and image rendering
            snacks-nvim
          ];
        };
        general = {
          lazy = true;
          after = ["ui"];
          extraPackages = with pkgs; [
            # For finding files - Modern replacement for `find`
            fd

            # For finding files containing specific text
            ripgrep
          ];
          data = with pkgs.vimPlugins; [
            # Syntax highlighting + code structure, LSP and autocompletion
            nvim-treesitter.withAllGrammars
            nvim-treesitter-textobjects
            nvim-lspconfig
            blink-cmp

            # Shows available keymaps as you type
            which-key-nvim

            # File explorer
            fyler-nvim

            # Git integration
            gitsigns-nvim

            # Discord rich presence
            cord-nvim
          ];
        };
        qualityOfLife = {
          lazy = true;
          after = ["general"];
          extraPackages = with pkgs; [
            # For `snacks.images`
            ghostscript # To render PDF files
            tectonic # To render LaTeX math expressions
            mermaid-cli # To render Mermaid diagrams
          ];
          data = with pkgs.vimPlugins; [
            # Code folding
            nvim-ufo

            # Autopairs characters e.g. `()`
            nvim-autopairs

            # Manipulate pairs of characters e.g. replacing an autopair with a motion
            mini-surround

            # More `a` and `i` text objects to improve motions
            mini-ai

            # Session management
            mini-sessions

            # Live preview Markdown and many other files in the browser
            live-preview-nvim

            # Auto-close and auto-rename HTML tags using Treesitter
            nvim-ts-autotag
          ];
        };
      };

      # This submodule modifies both levels of your specs
      extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [])) [];
      specMods = _: {
        # Change/Set defaults for the specs
        options = {
          extraPackages = lib.mkOption {
            type = lib.types.listOf wlib.types.stringable;
            default = [];
            description = "An `extraPackages` spec field to put packages to suffix to the PATH";
          };
        };
      };
    };
  };
}
