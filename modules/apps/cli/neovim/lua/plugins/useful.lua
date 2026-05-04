return {
	-- Shows available keymaps as you type
	{
		"which-key.nvim",
		after = function()
			require("which-key").setup({
				preset = "helix",
			})
		end,
	},

	-- File explorer
	{
		"fyler.nvim",
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Fyler kind=float<cr>", mode = "n", desc = "Toggle file explorer" },
		},
		after = function()
			require("fyler").setup()
		end,
	},

	-- Autopairing
	{
		"nvim-autopairs",
		after = function()
			require("nvim-autopairs").setup()
		end,
	},

	-- Code folding
	{
		"nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"zR",
				mode = "n",
				desc = "Open all folds",
				function()
					require("ufo").openAllFolds()
				end,
			},
			{
				"zM",
				mode = "n",
				desc = "Close all folds",
				function()
					require("ufo").closeAllFolds()
				end,
			},
		},
		before = function()
			local o = vim.opt
			o.foldenable = true
			o.foldlevel = 99
			o.foldlevelstart = 99
			o.foldcolumn = "1"
		end,
		after = function()
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},

	-- Git integration
	{
		"gitsigns.nvim",
		event = "BufReadPost",
	},

	-- Auto-close and auto-rename HTML tags using Treesitter
	{
		"nvim-ts-autotag",
		after = function()
			require("nvim-ts-autotag").setup()
		end,
	},
}
