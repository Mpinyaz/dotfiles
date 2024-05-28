return {
	"akinsho/toggleterm.nvim",
	-- tag = "*",
	config = function()
		local status_ok, toggleterm = pcall(require, "toggleterm")
		if not status_ok then
			return
		end

		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
		local yazi = Terminal:new({ cmd = "yazi", hidden = true })

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		function _YAZI_TOGGLE()
			yazi:toggle()
		end

		vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>lua _YAZI_TOGGLE()<CR>", { noremap = true, silent = true })
		toggleterm.setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})
	end,
}
