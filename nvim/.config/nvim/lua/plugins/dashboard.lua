local logo = {
        "███╗   ███╗██████╗ ██╗███╗   ██╗██╗   ██╗ █████╗ ███████╗",
        "████╗ ████║██╔══██╗██║████╗  ██║╚██╗ ██╔╝██╔══██╗╚══███╔╝",
        "██╔████╔██║██████╔╝██║██╔██╗ ██║ ╚████╔╝ ███████║  ███╔╝",
        "██║╚██╔╝██║██╔═══╝ ██║██║╚██╗██║  ╚██╔╝  ██╔══██║ ███╔╝",
        "██║ ╚═╝ ██║██║     ██║██║ ╚████║   ██║   ██║  ██║███████╗",
        "╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝",
}
return {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
                -- vim.api.nvim_create_autocmd("TabNewEntered", { command = "Dashboard" })
                require("dashboard").setup({
                        theme = "hyper",
                        config = {

                                project = {
                                        enable = false,
                                        limit = 8,
                                        action = "Telescope projects",
                                },
                                header = logo,
                                footer = { "🎉 Exiting Neovim is a life skill!" },
                                shortcut = {
                                        {
                                                icon = " ",
                                                desc = "New file",
                                                key = "n",
                                                action = "tabnew|startinsert",
                                        },
                                        {
                                                desc = " Check",
                                                group = "@property",
                                                action = "checkhealth",
                                                key = "c",
                                        },
                                        {
                                                desc = " Lazy",
                                                group = "@property",
                                                action = "Lazy",
                                                key = "l",
                                        },
                                        {
                                                icon = " ",
                                                icon_hl = "@variable",
                                                desc = "Files[SPC-SPC]",
                                                group = "Label",
                                                action = "Telescope find_files",
                                                -- key = 'f',
                                        },
                                        {
                                                icon = " ",
                                                icon_hl = "@variable",
                                                desc = "Projects[SPC-fp]",
                                                group = "Label",
                                                action = "Telescope projects",
                                                -- key = 'r',
                                        },
                                        {
                                                icon = " ",
                                                icon_hl = "@variable",
                                                desc = "Recent Files[SPC-fo]",
                                                group = "Label",
                                                action = "Telescope oldfiles",
                                                -- key = 'r',
                                        },
                                },
                        },
                })
        end,
}
