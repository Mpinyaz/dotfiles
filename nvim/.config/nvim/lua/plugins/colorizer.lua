return {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        opts = {
                render = "foreground",
                enabled_tailwind = true,
                virtual_symbol = "",
        },
        keys = {
                {
                        "<leader>mc",
                        function()
                                require("nvim-highlight-colors").toggle()
                        end,
                        desc = "Toggle highlight-colors",
                },
        },
        config = function()
                require("nvim-highlight-colors").setup({})
        end,
}
