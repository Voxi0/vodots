return {
  "snacks.nvim",
  on_plugin = "milli.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    -- Terminal and Git TUI
    {
      mode = "n",
      desc = "Open terminal",
      "<C-t>",
      function()
        Snacks.terminal()
      end,
    },
    {
      mode = "n",
      desc = "Open LazyGit",
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
    },

    -- Quickly rename files
    {
      mode = "n",
      desc = "Quick rename current file",
      "<leader>rN",
      function()
        Snacks.rename.rename_file()
      end,
    },

    -- Misc
    {
      mode = "n",
      desc = "Find icons",
      "<leader>fi",
      function()
        Snacks.picker.icons({ layout = "select" })
      end,
    },
  },
  after = function()
    -- Load animation frames
    local splash = require("milli").load({ splash = "blackhole" })

    -- Configure and initialize `snacks.nvim`
    require("snacks").setup({
      picker = {}, -- Picker for files and other stuff
      lazygit = {}, -- TUI for Git
      scroll = {}, -- Lazy scrolling
      image = {}, -- Image support
      rename = {}, -- Quick rename files
      notifier = {}, -- Prettier notifications
      statuscolumn = {}, -- Prettier/Cleaner statuscolumn
      bigfile = {}, -- Deal with big files quickly and efficiently

      -- Dashboard
      dashboard = {
        enabled = true,
        preset = {
          -- Display animated header using the frames
          header = table.concat(splash.frames[1], "\n"),

          -- Menu action keys obviously
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua require('fzf-lua').files({hidden = true})" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua require('fzf-lua').live_grep()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header", padding = 1 },
          { section = "keys", gap = 1, padding = 1 },
        },
      },
    })

    -- Integrate `milli.nvim` with `snacks.nvim`
    require("milli").snacks({ splash = "blackhole", loop = true })
  end,
}
