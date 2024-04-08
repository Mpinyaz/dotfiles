return {
	{ "bluz71/vim-nightfly-guicolors" },
	-- {
	-- 	"rose-pine/neovim",
	-- 	name = "rose-pine",
	-- 	config = function()
	-- 		vim.g.rose_pine_variant = "auto"
	-- 		vim.g.rose_pine_disable_background = true
	-- 		vim.cmd("colorscheme rose-pine")
	-- 	end,
	-- },
	"folke/tokyonight.nvim",
	{
		-- "catppuccin/nvim",
		-- name = "catppuccin",
		-- priority = 1000,
		-- config = function()
		-- 	require("catppuccin").setup({
		-- 		flavour = "mocha", -- latte, frappe, macchiato, mocha
		-- 		background = { -- :h background
		-- 			light = "latte",
		-- 			dark = "mocha",
		-- 		},
		-- 		transparent_background = true,
		-- 		integrations = {
		-- 			cmp = true,
		-- 			gitsigns = true,
		-- 			nvimtree = true,
		-- 			treesitter = true,
		-- 			leap = true,
		-- 			notify = true,
		-- 			mini = false,
		-- 		},
		-- 	})
		--
		-- 	vim.cmd.colorscheme("catppuccin")
		-- end,
	},
	{
		"tiagovla/tokyodark.nvim",
		opts = {
			-- custom options here
		},
		config = function(_, opts)
			require("tokyodark").setup(opts) -- calling setup is optional
			vim.cmd([[colorscheme tokyodark]])
		end,
	},
}
