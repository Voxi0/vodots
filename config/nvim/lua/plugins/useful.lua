return {
  -- Show available keymaps as you type
  {
    "which-key.nvim",
    after = function()
      require("which-key").setup({ preset = "helix" })
    end,
  },

  -- Improve Neovim's builtin file explorer
  {
    "oil.nvim",
    lazy = false,
    keys = {
      { mode = "n", desc = "Open file explorer", "<leader>e", function() require("oil").open_float() end },
    },
    after = function()
      require("oil").setup({
        win_options = { cursorcolumn = true },
        view_options = { show_hidden = true },
        keymaps = {
          ["q"] = "actions.close",
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 20,
          border = "rounded", -- "rounded", "single", or "double"
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
  },

  {
    "fzf-lua",
    on_require = "fzf-lua",
    keys = {
      -- Core necessities
      {
        mode = "n",
        desc = "Find files",
        "<leader>ff",
        function()
          require("fzf-lua").files({ hidden = true })
        end,
      },
      {
        mode = "n",
        desc = "Grep files",
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
      },
      {
        mode = "n",
        desc = "Grep current word",
        "<leader>gw",
        function()
          require("fzf-lua").grep_cword()
        end,
      },
      {
        mode = "n",
        desc = "Grep visual selection",
        "<leader>gv",
        function()
          require("fzf-lua").grep_visual()
        end,
      },

      -- LSP
      {
        mode = "n",
        desc = "Find LSP definitions",
        "<leader>fd",
        function()
          require("fzf-lua").lsp_definitions()
        end,
      },
      {
        mode = "n",
        desc = "Find LSP references",
        "<leader>fr",
        function()
          require("fzf-lua").lsp_references()
        end,
      },
      {
        mode = "n",
        desc = "Find LSP document symbols",
        "<leader>ds",
        function()
          require("fzf-lua").lsp_document_symbols()
        end,
      },
      {
        mode = "n",
        desc = "Find LSP document diagnostics/errors",
        "<leader>fd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
      },
      {
        mode = "n",
        desc = "Find LSP workspace diagnostics/errors",
        "<leader>fD",
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
      },

      -- Misc
      {
        mode = "n",
        desc = "Find misspelled words",
        "<leader>sc",
        function()
          require("fzf-lua").spellcheck()
        end,
      },
      {
        mode = "n",
        desc = "Colorschemes",
        "<leader>th",
        function()
          require("fzf-lua").colorschemes()
        end,
      },
      {
        mode = "n",
        desc = "Awesome colorschemes",
        "<leader>tH",
        function()
          require("fzf-lua").awesome_colorschemes()
        end,
      },

      -- Help
      {
        mode = "n",
        desc = "Find help",
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
      },
      {
        mode = "n",
        desc = "Find man page",
        "<leader>fm",
        function()
          require("fzf-lua").man_pages()
        end,
      },
      {
        mode = "n",
        desc = "Find keymaps",
        "<leader>fk",
        function()
          require("fzf-lua").keymaps()
        end,
      },
    },
    after = function()
      require("fzf-lua").setup({
        winopts = { preview = { hidden = true } },
      })
    end,
  },

  -- Automatically manage character pairs
  {
    "nvim-autopairs",
    event = { "CmdlineEnter", "InsertEnter" },
    after = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Manipulate character pairs
  {
    "mini.surround",
    event = "BufReadPost",
    after = function()
      require("mini.surround").setup()
    end,
  },

  -- Code folding
  {
    "nvim-ufo",
    on_plugin = "promise-async",
    event = "BufReadPost",
    keys = {
      {
        mode = "n",
        desc = "Open all folds",
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
      },
      {
        mode = "n",
        desc = "Open all folds",
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
      },
    },
    after = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      })
    end,
  },

  -- Treesitter textobjects for more code-aware Vim motions
  -- Extends `mini.ai` to give it more textobjects to work with
  {
    "nvim-treesitter-textobjects",
    on_plugin = "nvim-treesitter",
    dep_of = "mini.ai",
  },

  -- Auto-close and auto-rename HTML tags using Treesitter
  {
    "nvim-ts-autotag",
    on_plugin = "nvim-treesitter",
    ft = { "html", "astro", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "xml" },
    after = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- More textobjects for nicer Vim motions
  {
    "mini.ai",
    on_plugin = "nvim-treesitter-textobjects",
    event = "BufReadPost",
    after = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          -- Block-like objects
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),

          -- Functions
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),

          -- Classes
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      })
    end,
  },

  -- Color highlighter - Highlights color codes in your code
  {
    "nvim-colorizer.lua",
    event = "BufReadPost",
    after = function()
      require("colorizer").setup()
    end,
  },

  -- Markdown preview
  {
    "markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    after = function()
      -- Refresh Markdown preview when saving the buffer or leaving insert mode
      vim.g.mkdp_refresh_slow = 0
    end,
  },
}
