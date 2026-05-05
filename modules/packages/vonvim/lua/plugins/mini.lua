return {
	-- Add, delete, replace, find and highlight surrounding e.g. a pair of parenthesis, quotes, etc.
	{
		"mini.surround",
		event = "InsertEnter",
		after = function()
			require("mini.surround").setup()
		end,
	},

	-- Extend `a` and `i` text objects
	{
		"mini.ai",
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

	-- Session management
	{
		"mini.sessions",
		keys = {
			{
				"<leader>ls",
				mode = "n",
				desc = "Load session",
				function()
					MiniSessions.read()
				end,
			},
		},
		after = function()
			require("mini.sessions").setup({
				autoread = false,
				autowrite = true,

				-- File for local session
				file = "Session.vim",

				-- Whether to print session path after action
				verbose = { read = false, write = true, delete = true },
			})
		end,
	},
}
