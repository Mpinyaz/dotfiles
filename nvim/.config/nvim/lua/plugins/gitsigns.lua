return {
	{ "tpope/vim-rhubarb", keys = { { "n", "<leader>gb", ":Gbrowse<cr>", desc = "Open in browser" } } },
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		keys = {
			"<leader>gq",
			":GitConflictQf<CR>",
			desc = "Git conflict",
			{ noremap = true, silent = true },
		},

		config = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictDetected",
				callback = function()
					vim.notify("Conflict detected in file " .. vim.api.nvim_buf_get_name(0))
					vim.cmd("LspStop")
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "GitConflictResolved",
				callback = function()
					vim.cmd("LspRestart")
				end,
			})
		end,
	},
	{
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
	},
	{
		"ThePrimeagen/git-worktree.nvim",
		opts = {},
		config = function()
			require("telescope").load_extension("git_worktree")
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
                --stylua: ignore
                keys = {
                        { "<leader>gwm",
                                function() require("telescope").extensions.git_worktree.git_worktrees() end,
                                desc = "Manage" },
                        { "<leader>gwc",
                                function() require("telescope").extensions.git_worktree.create_git_worktree() end,
                                desc = "Create" },
                },
	},
}
