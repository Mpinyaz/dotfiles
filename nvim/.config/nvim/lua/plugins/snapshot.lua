return {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	init = function()
		local wk = require("which-key")
		wk.add({ "<leader>cs", "<cmd>Silicon<cr>", desc = "Silicon", mode = "v" })
	end,
	config = function()
		require("silicon").setup({
			font = "Agave Nerd Font Mono=34;",
			theme = "Dracula",
			background = "#282a36",
			window_title = function()
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
			end,
		})
	end,
}
