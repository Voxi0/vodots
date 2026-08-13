return {
  -- Pre-written LSP configurations
  {
    "nvim-lspconfig",
    lazy = false,
    after = function()
      -- Extend LSP configurations
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              -- Disable prompts about third-party libraries
              checkThirdParty = false,

              -- Pass Neovim's Lua API to the LSP server so it knows about `vim.*`
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })

      -- Enable LSPs
      vim.lsp.enable({ "lua_ls", "nil_ls" })
    end,
  },

  -- Autocompletion
  {
    "blink.cmp",
    on_plugin = "blink.lib",
    event = "InsertEnter",
    build = function()
      -- Build the fuzzy matcher
      require("blink.cmp").build():pwait()
    end,
    after = function()
      require("blink.cmp").setup({
        -- Ghost text only in command line
        cmdline = { completion = { ghost_text = { enabled = true } } },

        keymap = {
          -- Get rid of all preset key-mappings
          preset = "none",

          -- Go up and down
          ["<C-j>"] = { "select_next" },
          ["<C-k>"] = { "select_prev" },
          ["<Down>"] = { "scroll_documentation_down", "fallback" },
          ["<Up>"] = { "scroll_documentation_up", "fallback" },

          -- Documentation
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

          -- Accept or cancel suggestion
          ["<Tab>"] = { "accept", "fallback" },
        },
      })

      -- Pass LSP capabilities to all available servers I dunno
      local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
      lspCapabilities = require("blink.cmp").get_lsp_capabilities(lspCapabilities)
      vim.lsp.config("*", { capabilities = lspCapabilities })
    end,
  },
}
