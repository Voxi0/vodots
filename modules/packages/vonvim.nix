{inputs, ...}: {
  # Export custom Neovim configuration as a package
  flake.wrappers.vonvim = {
    wlib,
    config,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.neovim];
    settings.config_directory = ../../config/nvim;

    # Runtime dependencies
    runtimePkgs = with pkgs; [
      inotify-tools # Faster/Better file watcher backend
      ripgrep # Recursively search directories for a regex pattern while respecting your `.gitignore`
      fd # Quickly find entries in your filesystem
      fzf # Command line fuzzy finder required for `fzf-lua`
      ghostscript # Required for rendering PDF files
      tectonic # Required for rendering LaTeX math expressions
      mermaid-cli # Required for rendering Mermaid diagrams
    ];

    # Plugins
    specs = {
      # Lazy loading library to manage plugins
      plugin-manager.data = pkgs.vimPlugins.lze;

      ###############################
      ### Non-Lazy Loaded Plugins ###
      ###############################
      # Just dependencies for other plugins here mainly
      startup = {
        after = ["plugin-manager"];
        data = with pkgs.vimPlugins; [
          # Dependencies for other plugins
          nvim-web-devicons # Icons
          promise-async # Dependency for `nvim-ufo`

          # Syntax highlighting and code folding
          # Treesitter and query files should be available on startup to avoid issues
          (nvim-treesitter.withPlugins (
            p:
              with p; [
                nix
                lua
              ]
          ))
        ];
      };

      ########################
      ### Core Necessities ###
      ########################
      core = {
        lazy = true;
        after = ["startup"];
        data = with pkgs.vimPlugins;
          [
            # Pre-written LSP configurations
            nvim-lspconfig

            # More code-aware Vim motions and all
            nvim-treesitter-textobjects
            nvim-ts-autotag

            # Quality of life plugins
            which-key-nvim # Show available keymaps as you type
            oil-nvim # File explorer
            fzf-lua # Fast fuzzy finder using `fzf` binary
            snacks-nvim # Collection of plugins e.g. picker and image support
            nvim-autopairs # Automatically manage character pairs
            mini-surround # Manipulate character pairs
            nvim-ufo # Code folding
            mini-ai # More textobjects for nicer Vim motions
            nvim-colorizer-lua # Color highlighter - Highlights color codes in your code
            markdown-preview-nvim # Markdown preview
          ]
          ++ [
            # Autocompletion
            inputs.blink-cmp-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
      };

      ##########
      ### UI ###
      ##########
      # For animated splashscreen header thingy on the dashboard `snacks.dashboard`
      milli-nvim = {
        before = ["core"]; # Because `snacks.nvim` requires this plugin
        data = config.nvim-lib.mkPlugin "milli.nvim" inputs.milli-nvim;
      };
      ui = {
        lazy = true;
        after = ["core"];
        data = with pkgs.vimPlugins; [
          neovim-ayu # Theme/Colorscheme
          lualine-nvim # Fast and configurable statusline
          tiny-cmdline-nvim # Prettier floating command line
          blink-indent # Indentation guides
          visual-whitespace-nvim # Visualize whitespace
          gitsigns-nvim # Git integration
        ];
      };

      #####################
      ### Miscellaneous ###
      #####################
      # Nice to have but not necessarily useful
      cord-nvim = {
        after = ["startup"];
        data = config.nvim-lib.mkPlugin "cord.nvim" inputs.cord-nvim;
      };
      misc = {
        lazy = true;
        after = ["ui"];
        data = with pkgs.vimPlugins; [
          # Markdown preview
          peek-nvim
        ];
      };
    };
  };
}