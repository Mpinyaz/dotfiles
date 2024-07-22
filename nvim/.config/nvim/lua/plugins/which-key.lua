return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	cmd = "WhichKey",
	init = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>lg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
		})
	end,
	opts = {
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
		},
		show_help = true,
	},
}
