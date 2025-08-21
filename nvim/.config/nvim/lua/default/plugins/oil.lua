return {
        "stevearc/oil.nvim",
        cmd = "Oil",
        opts = {},
        init = function() -- Load oil on startup only when editing a directory
                vim.g.loaded_fzf_file_explorer = 1
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
        end,
        config = function() end,
}
