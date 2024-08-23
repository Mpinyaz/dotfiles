return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "md",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("obsidian").setup({
			workspaces = {
				{
					name = "Notes",
					path = "/Users/eltonmpinyuri/Documents/Obsidian Vault/",
				},
			},
		})
	end,
}
