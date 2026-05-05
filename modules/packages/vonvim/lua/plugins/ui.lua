return {
	-- Theme
	{
		"catppuccin-nvim",
		lazy = false,
		priority = 1000,
		colorscheme = "catppuccin",
		after = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				color_overrides = {
					mocha = {
						base = "#000000",
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

	-- Icons
	{
		"mini.icons",
		lazy = false,
		after = function()
			local icons = require("mini.icons")
			icons.setup()
			icons.mock_nvim_web_devicons()
		end,
	},

	-- Statusline
	{
		"lualine.nvim",
		lazy = false,
		after = function()
			require("lualine").setup({
				options = {
					-- Have a single statusline at the bottom instead of one for every window
					-- Ensures that Lualine doesn't get replaced with the default statusline when a `mini.picker` window is open for example
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					refresh = {
						events = {
							"WinEnter",
							"BufEnter",
							"BufWritePost",
							"SessionLoadPost",
							"FileChangedShellPost",
							"VimResized",
							"Filetype",
							"ModeChanged",
						},
					},
				},
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

	-- Completely replaces the UI for messages, cmdline and the popupmenu
	{
		"noice.nvim",
		event = "DeferredUIEnter",
		after = function()
			require("noice").setup({
				lsp = {
					-- Override markdown rendering so that plugins use Treesitter
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
					},
				},
				presets = {
					bottom_search = true, -- Classic bottom cmdline for search
					command_palette = true, -- Position the cmdline and popupmenu together
					long_message_to_split = true, -- Long messages will be sent to a split
					inc_rename = false, -- Enable an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- Add a border to hover docs and signature help
				},
			})
		end,
	},
}
