return {
        { "tpope/vim-rhubarb", keys = { { "n", "<leader>gb", ":Gbrowse<cr>", desc = "Open in browser" } } },
        -- {
        -- 	"akinsho/git-conflict.nvim",
        -- 	version = "*",
        -- 	keys = {
        -- 		"<leader>gq",
        -- 		":GitConflictQf<CR>",
        -- 		desc = "Git conflict",
        -- 		{ noremap = true, silent = true },
        -- 	},
        --
        -- 	config = function()
        -- 		vim.api.nvim_create_autocmd("User", {
        -- 			pattern = "GitConflictDetected",
        -- 			callback = function()
        -- 				vim.notify("Conflict detected in file " .. vim.api.nvim_buf_get_name(0))
        -- 				vim.cmd("LspStop")
        -- 			end,
        -- 		})
        --
        -- 		vim.api.nvim_create_autocmd("User", {
        -- 			pattern = "GitConflictResolved",
        -- 			callback = function()
        -- 				vim.cmd("LspRestart")
        -- 			end,
        -- 		})
        -- 	end,
        -- },
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

                                        map("n", "<leader>gs", "<cmd>Git<cr>", "Git status")
                                        map("n", "<leader>gw", "<cmd>Gwrite<cr>", "Git add")
                                        map("n", "<leader>gc", "<cmd>Git commit<cr>", "Git commit")
                                        map("n", "<leader>gd", "<cmd>gdiffsplit<cr>", "git diff")
                                        map("n", "<leader>gpl", "<cmd>Git pull<cr>", "Git pull")
                                        map("n", "<leader>gpu", "<cmd>15 split|term git push<cr>", "Git push")
                                        map({ "n", "v" }, "<leader>gx", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                                        map("n", "<leader>gh", gs.preview_hunk, "Preview Hunk")
                                        map("n", "<leader>gX", gs.reset_buffer, "Reset Buffer")
                                        map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
                                        -- map("n", "<leader>gb", function()
                                        --         gs.blame_line({ full = true })
                                        -- end, "Blame Line")
                                        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
                                end,
                        }
                        return C
                end,
                keys = {
                        -- git stage
                        { "<leader>gg", ":Gitsigns stage_hunk<CR>",      desc = "Stage Hunk" },
                        { "<leader>gG", ":Gitsigns stage_buffer<CR>",    desc = "Stage Buffer" },
                        { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },

                        -- git hunk navigation
                        { "gH",         ":Gitsigns prev_hunk<CR>",       desc = "Goto previous git hunk" },
                        { "]g",         ":Gitsigns next_hunk<CR>",       desc = "Goto next git hunk" },
                        { "[g",         ":Gitsigns prev_hunk<CR>",       desc = "Goto previous git hunk" },
                },
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
