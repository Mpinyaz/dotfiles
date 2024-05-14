return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({
			-- Configuration here, or leave empty to use defaults
			keymaps = { -- vim-surround style keymaps
				insert = "<C-s>",
			},
			aliases = {
				["a"] = "a",
				["b"] = "b",
				["B"] = "B",
				["r"] = "r",
				["q"] = { '"', "'", "`" }, -- Any quote character
				[";"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
			},
		})
	end,
}
