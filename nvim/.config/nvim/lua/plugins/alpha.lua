return {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
                local dashboard = require("alpha.themes.dashboard")
                require("alpha.term")
                local alpha = require("alpha")
                dashboard.section.header.val = {
                        [[███╗   ███╗██████╗ ██╗███╗   ██╗██╗   ██╗ █████╗ ███████╗]],
                        [[████╗ ████║██╔══██╗██║████╗  ██║╚██╗ ██╔╝██╔══██╗╚══███╔╝]],
                        [[██╔████╔██║██████╔╝██║██╔██╗ ██║ ╚████╔╝ ███████║  ███╔╝]],
                        [[██║╚██╔╝██║██╔═══╝ ██║██║╚██╗██║  ╚██╔╝  ██╔══██║ ███╔╝]],
                        [[██║ ╚═╝ ██║██║     ██║██║ ╚████║   ██║   ██║  ██║███████╗]],
                        [[╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝]],
                }

                dashboard.section.buttons.val = {
                        dashboard.button("i", "    new file", ":ene <BAR> startinsert<CR>"),
                        dashboard.button("o", "    old files", ":Telescope oldfiles<CR>"),
                        dashboard.button("f", "󰥨    find file", ":Telescope file_browser<CR>"),
                        dashboard.button("g", "󰱼    find text", ":Telescope live_grep_args<CR>"),
                        dashboard.button("l", "󰒲    lazy", ":Lazy<CR>"),
                        dashboard.button("m", "󱌣    mason", ":Mason<CR>"),
                        dashboard.button("p", "󰄉    profile", ":Lazy profile<CR>"),
                        dashboard.button("q", "󰭿    quit", ":qa<CR>"),
                        dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
                }
                -- close lazy and re-open when the dashboard is ready
                if vim.o.filetype == "lazy" then
                        vim.cmd.close()
                        vim.api.nvim_create_autocmd("User", {
                                pattern = "AlphaReady",
                                callback = function()
                                        require("lazy").show()
                                end,
                        })
                end
                vim.api.nvim_create_autocmd("User", {
                        pattern = "LazyVimStarted",
                        callback = function()
                                local stats = require("lazy").stats()
                                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                                dashboard.section.footer.val = "󱐋 " .. stats.count .. " plugins loaded in " .. ms .. "ms"
                                pcall(vim.cmd.AlphaRedraw)
                        end,
                })
                for _, button in ipairs(dashboard.section.buttons.val) do
                        if button.on_press then
                                button.opts.hl = "AlphaButtons"
                                button.opts.hl_shortcut = "AlphaShortcut"
                        end
                end
                dashboard.section.buttons.opts.spacing = 0
                alpha.setup(dashboard.opts)
        end,
}
