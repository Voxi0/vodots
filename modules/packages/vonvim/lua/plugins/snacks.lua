return {
	"snacks.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		--------------
		--- Picker ---
		--------------
		-- Files
		{
			"<leader>ff",
			mode = "n",
			desc = "Open file picker",
			function()
				Snacks.picker.files({ hidden = true })
			end,
		},

		-- Buffers
		{
			"<leader>fb",
			mode = "n",
			desc = "Buffers",
			function()
				Snacks.picker.buffers()
			end,
		},

		-- Grep
		{
			"<leader>sg",
			desc = "Grep",
			function()
				Snacks.picker.grep()
			end,
		},
		{
			"<leader>sb",
			desc = "Buffer Lines",
			function()
				Snacks.picker.lines({
					layout = { preset = "vscode" },
				})
			end,
		},
		{
			"<leader>sB",
			desc = "Grep Open Buffers",
			function()
				Snacks.picker.grep_buffers()
			end,
		},
		{
			"<leader>sw",
			mode = { "n", "x" },
			desc = "Visual selection or word",
			function()
				Snacks.picker.grep_word()
			end,
		},

		-- Help / Man
		{
			"<leader>sh",
			mode = "n",
			desc = "Search help pages",
			function()
				Snacks.picker.help()
			end,
		},
		{
			"<leader>sm",
			mode = "n",
			desc = "Search man pages",
			function()
				Snacks.picker.man()
			end,
		},

		-- Themes/Colorschemes
		{
			"<leader>th",
			mode = "n",
			desc = "Search themes/colorschemes",
			function()
				Snacks.picker.colorschemes()
			end,
		},

		---------------
		--- LazyGit ---
		---------------
		{
			"<leader>gg",
			mode = "n",
			desc = "Open LazyGit",
			function()
				Snacks.lazygit()
			end,
		},
	},
	after = function()
		require("snacks").setup({
			-- Indentation guides
			indent = {},

			-- Better statuscolumn
			statuscolumn = {},

			-- Smooth scrolling
			scroll = {},

			-- TUI for Git
			lazygit = {},

			-- Renders images
			image = {},

			-- Dashboard
			dashboard = {
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
				},
			},

			-- Picker
			picker = {
				hidden = { "preview" },
				layout = {
					layout = {
						backdrop = false,
						row = 1,
						width = 0.4,
						min_width = 80,
						height = 0.4,
						border = "none",
						box = "vertical",
						{
							win = "input",
							height = 1,
							border = true,
							title = "{title} {live} {flags}",
							title_pos = "center",
						},
						{ win = "list", border = true },
					},
				},
			},
		})
	end,
}
