return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	cmd = "WhichKey",
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	opts = {
		preset = "modern",
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
		spec = {
			{ "<leader>b", group = "Buffers" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>g", group = "Git" },
			{ "<leader>Qf", group = "Quickfix" },
			{ "<leader>R", group = "Replace" },
			{ "<leader>s", group = "Search" },
			{ "<leader>z", group = "Spelling" },
		},
		show_help = true,
	},
}
