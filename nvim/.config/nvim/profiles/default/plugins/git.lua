return {
	{
		"tpope/vim-rhubarb",
		keys = { { "n", "<leader>gb", ":Gbrowse<cr>", desc = "Open in browser" } },
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		config = true,
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = { winbar_info = true },
				file_history = { winbar_info = true },
			},
		},
		keys = {
			{ "<leader>gdo", "<cmd>DiffviewOpen<cr>" },
			{ "<leader>gdc", "<cmd>DiffviewClose<cr>" },
			{ "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		-- Git integration for buffers
		event = "BufReadPre",
		opts = function()
			local icons = require("config.icons")
			--- @type Gitsigns.Config
			local C = {
				signs = {
					add = { text = icons.git.added },
					change = { text = icons.git.changed },
					delete = { text = icons.git.deleted },
					topdelete = { text = icons.git.deleted },
					changedelete = { text = icons.git.changed },
					untracked = { text = icons.git.added },
				},
				on_attach = function(buffer)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
					end
					map("n", "]h", gs.next_hunk, "Next Hunk")
					map("n", "[h", gs.prev_hunk, "Prev Hunk")
					map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
					map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
					map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
					map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
					map("n", "<leader>hc", "<cmd>Git commit<cr>", "Git commit")
					map("n", "<leader>hd", gs.diffthis, "git diff")
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, "Git diff this file")
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Stage hunk")
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, "Reset hunk")
					map({ "n", "v" }, "<leader>hx", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
					map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
					map("n", "<leader>hP", gs.preview_hunk_inline, "Preview Hunk")
					map("n", "<leader>hX", gs.reset_buffer, "Reset Buffer")
					map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, "Blame Line")
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
				end,
			}
			return C
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
                        {
                                "<leader>gwm",
                                function() require("telescope").extensions.git_worktree.git_worktrees() end,
                                desc = "Manage"
                        },
                        {
                                "<leader>gwc",
                                function() require("telescope").extensions.git_worktree.create_git_worktree() end,
                                desc = "Create"
                        },
                },
	},
}
