return {
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
		init = function()
			local wk = require("which-key")
			wk.register({
				["/"] = {
					function()
						require("Comment.api").toggle.linewise.current()
					end,
					"Toggle comment",
				},
			}, {
				prefix = "<leader>",
				mode = "n",
			})
			wk.register({
				["/"] = {
					"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
					"Toggle comment",
				},
			}, {
				prefix = "<leader>",
				mode = "v",
			})
		end,
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("ts_context_commentstring").setup({})
		end,
	},
}
