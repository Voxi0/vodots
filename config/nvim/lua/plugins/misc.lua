return {
  -- Discord rich presence
  {
    "cord.nvim",
    event = "UIEnter",
    after = function()
      require("cord").setup({
        -- Theme
        display = { theme = "minecraft" },

        -- Share timestamp between Neovim instances
        timestamp = { shared = true },

        editor = {
          tooltip = "mah favourite editor",
          icon = nil,
        },

        idle = {
          icon = nil,
          tooltip = "💤",
          details = "eepin'",
        },

        text = {
          default = nil,
          dashboard = "cozyin' up in home",
          workspace = function(opts)
            return "workin' in " .. opts.workspace
          end,
          viewing = function(opts)
            return "viewin' " .. opts.filename
          end,
          editing = function(opts)
            return "editin' " .. opts.filename
          end,
          file_browser = function(opts)
            return "browsin' in " .. opts.name
          end,
          lsp = function(opts)
            return "configurin' lsp in " .. opts.name
          end,
          docs = function(opts)
            return "readin' " .. opts.name
          end,
          vcs = function(opts)
            return "committin' changes in " .. opts.name
          end,
          debug = function(opts)
            return "debuggin' in " .. opts.name
          end,
          test = function(opts)
            return "testin' in " .. opts.name
          end,
          diagnostics = function(opts)
            return "fixin' problems in " .. opts.name
          end,
          games = function(opts)
            return "playin' " .. opts.name
          end,
          terminal = function(opts)
            return "runnin' commands in " .. opts.name
          end,
          plugin_manager = function(opts)
            return "managin' plugins in " .. opts.name
          end,
          notes = function(opts)
            return "takin' notes in " .. opts.name
          end,
        },
      })
    end,
  },
}
