return {
	"s1n7ax/nvim-comment-frame",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter" },
	},
	config = function()
		require("nvim-comment-frame").setup()
		vim.api.nvim_set_keymap("n", "<leader>cc", ":lua require('nvim-comment-frame').add_comment()<CR>", {})
	end,
}
