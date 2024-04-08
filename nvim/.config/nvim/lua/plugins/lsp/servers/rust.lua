return function(on_attach)
        return {
                on_attach = function(client, bufnr)
                        vim.keymap.set("n", "<leader>kk", rt.hover_actions.hover_actions, { buffer = bufnr })
                        vim.keymap.set({ "n", "v" }, "<leader>aa", rt.code_action_group.code_action_group,
                                { buffer = bufnr })
                        vim.keymap.set("n", "<leader>rdb", rt.debuggables.debuggables)
                        vim.keymap.set("n", "<leader>rr", rt.runnables.runnables)
                        vim.keymap.set("n", "<leader>rsh", rt.inlay_hints.set)
                        vim.keymap.set("n", "<leader>rhh", rt.inlay_hints.unset)
                        vim.keymap.set("n", "<leader>rmu", "<cmd>RustMoveItemUp<CR>")
                        vim.keymap.set("n", "<leader>rmd", "<cmd>RustMoveItemDown<CR>")
                        vim.api.nvim_buf_set_option(buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
                        vim.api.nvim_buf_set_option(buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
                        vim.api.nvim_buf_set_option(buf, "tagfunc", "v:lua.vim.lsp.tagfunc")
                end,
                --cmd = { "rustup", "run", "stable", "rust-analyzer" },
                settings = {
                        ["rust-analyzer"] = {
                                check = {
                                        command = "clippy",
                                        extraArgs = { "--all", "--", "-W", "clippy::all" },
                                },
                                checkOnSave = {
                                        command = "clippy",
                                },
                                assist = {
                                        importEnforceGranularity = true,
                                        importPrefix = "crate",
                                },
                                cargo = {
                                        allFeatures = true,
                                },
                                inlayHints = {
                                        locationLinks = false,
                                        lifetimeElisionHints = {
                                                enable = true,
                                                useParameterNames = true,
                                        },
                                },
                                procMacro = {
                                        ignored = {
                                                leptos_macro = {
                                                        -- optional: --
                                                        -- "component",
                                                        "server",
                                                },
                                        },
                                },
                        },
                },
        }
end
