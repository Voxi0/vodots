return {
	-- Discord rich presence
	{
		"cord.nvim",
		after = function()
			require("cord").setup({
				enabled = true,
				display = {
					theme = "default",
					flavor = "dark",
				},
				editor = {
					client = "neovim",
					tooltip = "the kewl editor",
					icon = nil,
				},
				timestamp = {
					enabled = true,
					reset_on_idle = false,
					reset_on_change = false,
				},
				idle = {
					enabled = true,
					show_status = true,
					smart_idle = true,
					details = "spacin' out",
					tooltip = "💤",
					icon = nil,
				},
			})
		end,
	},
}
