return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- See `:help gitsigns.txt`
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
	config = function()
		local status, gitsigns = pcall(require, "gitsigns")
		if not status then
			return
		end

		gitsigns.setup({})

		-- local keymap = vim.keymap
		--
		-- keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
		-- keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git add" })
		-- keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
		-- keymap.set("n", "<leader>gd", "<cmd>gdiffsplit<cr>", { desc = "git diff" })
		-- keymap.set("n", "<leader>gpl", "<cmd>Git pull<cr>", { desc = "Git pull" })
		-- keymap.set("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", { desc = "Git push" })
	end,
}
