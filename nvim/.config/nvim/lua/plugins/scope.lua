return {
	"tiagovla/scope.nvim",
	config = function()
		vim.opt.sessionoptions = { -- required
			"buffers",
			"tabpages",
			"globals",
		}
		require("scope").setup({
			cursor = true,
			cursor_highlight = "Cursor",
			scope_prefix = "scope",
			scope_enable = true,
			scope_cursor = true,
		})
	end,
}
