for key, value in pairs({
  -- Enable 24-bit colors - Required for most themes/colorschemes
  termguicolors = true,

  -- UI stuff
  cmdheight = 0, -- Make sure the command line is not visible at all
  showmode = false, -- Disable this since we're using Lualine instead anyways
  showcmd = false, -- Don't show command line when not being used

  -- Lines to keep above/below the cursor and columns left/right of the cursor
  scrolloff = 8,
  sidescrolloff = 12,

  -- Always show signcolumn so the text doesn't shift whenever you start/stop typing
  signcolumn = "yes",

  -- Window borders
  winborder = "rounded",
}) do
  vim.opt[key] = value
end

return {
  -- Theme/Colorscheme
  {
    "catppuccin-nvim",
    lazy = false,
    priority = 1000,
    colorscheme = "catppuccin",
    after = function()
      require("catppuccin").setup({
        flavour = "mocha",
        color_overrides = {
          mocha = {
            base = "#101010",
            mantle = "#010101",
            crust = "#020202",
          },
        },
        custom_highlights = function(colors)
          return {
            WinSeparator = { fg = colors.flamingo },
            SnacksPickerBorder = { fg = colors.red },
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Command line
  {
    "tiny-cmdline.nvim",
    event = "UIEnter",
    after = function()
      require("vim._core.ui2").enable()
      vim.opt.cmdheight = 0
      require("tiny-cmdline").setup({
        -- Integration with `blink.cmp`
        on_reposition = require("tiny-cmdline").adapters.blink,

        -- Enable window title
        title = { enabled = true },

        -- Position and size
        position = { y = "10%" },
        width = {
          value = "25%",
          min = 15,
          max = 80,
        },
      })
    end,
  },

  -- Statusline
  {
    "lualine.nvim",
    event = "UIEnter",
    after = function()
      require("lualine").setup({
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = {},
          lualine_y = { "diff", "lsp_status" },
          lualine_z = {
            {
              "datetime",
              style = "%I:%M %p",
            },
          },
        },
      })
    end,
  },

  -- Indentation guides
  {
    "blink.indent",
    event = "BufReadPre",
    keys = {
      {
        mode = "n",
        desc = "Toggle indentation guides",
        "<leader>tg",
        function()
          local indent = require("blink.indent")
          indent.enable(not indent.is_enabled())
        end,
      },
    },
    after = function()
      -- Set up custom colors for the highlight groups
      local colors = {
        BlinkIndentRed = "#E06C75",
        BlinkIndentOrange = "#D19A66",
        BlinkIndentYellow = "#E5C07B",
        BlinkIndentGreen = "#98C379",
        BlinkIndentViolet = "#C678DD",
        BlinkIndentCyan = "#56B6C2",
      }

      for hl, color in pairs(colors) do
        vim.api.nvim_set_hl(0, hl, { fg = color })
      end

      require("blink.indent").setup({
        indent = {
          enabled = true,
          highlights = {
            "BlinkIndentRed",
            "BlinkIndentOrange",
            "BlinkIndentYellow",
            "BlinkIndentGreen",
            "BlinkIndentViolet",
            "BlinkIndentCyan",
          },
        },
      })
    end,
  },

  -- Visualize whitespace
  {
    "visual-whitespace.nvim",
    event = "ModeChanged *:[vV\22]",
    after = function()
      require("visual-whitespace").setup()
    end,
  },

  -- Git integration
  { "gitsigns.nvim", event = "BufReadPost" },
}
