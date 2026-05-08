return {
	-- Required for `nvim-ts-autotag` to function properly
	{
		"nvim-treesitter",
		dep_of = "nvim-ts-autotag",
		event = "BufReadPost",
		after = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					----------------------------------------------
					--- Tries to attach Treesitter to a buffer ---
					----------------------------------------------
					local function treesitterTryAttach(buffer, language)
						-- Load parser for current language if it exists
						if not vim.treesitter.language.add(language) then
							return false
						end

						-- Enable syntax highlighting and other Treesitter features
						vim.treesitter.start(buffer, language)
					end

					-------------------------------------------
					--- Attach Treesitter to current buffer ---
					-------------------------------------------
					-- Check if Treesitter parser for buffer is available
					local language = vim.treesitter.language.get_lang(args.match)
					if not language then
						return
					end

					-- Try attaching Treesitter to current buffer
					treesitterTryAttach(args.buf, language)
				end,
			})
		end,
	},

	-- Treesitter textobjects for more codeaware Neovim motions
	-- Extends `mini.ai` to give it more textobjects to work with
	{
		"nvim-treesitter-textobjects",
		dep_of = "mini.ai",
	},

	-- Pre-written configurations for many LSPs that can be used out of the box
	{
		"nvim-lspconfig",
		event = "BufReadPost",
	},

	-- Autocompletion
	{
		"blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		after = function()
			require("blink-cmp").setup({
				-- Show function signature
				signature = { enabled = true },

				-- Keybindings
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
		end,
	},
}
